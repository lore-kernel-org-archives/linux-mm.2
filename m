Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A572CF41808
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3EFB6B0005; Mon,  9 Mar 2026 11:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED4A6B0088; Mon,  9 Mar 2026 11:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2636B008A; Mon,  9 Mar 2026 11:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96CA96B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:32:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C42BC132D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:32:53 +0000 (UTC)
X-FDA: 84526917426.09.DBBA49D
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1D41D40016
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:32:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="C0/fof7C";
	spf=pass (imf11.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773070371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRT7Jgm9N7KfkB30wEfzPmwAeXhxzgWE6zagZwlL4ns=;
	b=sp5kuiE9SAP2YtvoCHseieHuBYdAea0MAul3FijtJdjmS6VSVFSHQZRe3pOfnr9Obm/XeW
	qMF0JQEzqMOj1Kl0TcWi2Qi7XTHLMLOJ0FOEkUjFPq+oPvrFUR1txYr4vIDSKY/5RqB0BK
	Sam0pBYSZTjRMCQxmshqkzCcGMI9Boc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="C0/fof7C";
	spf=pass (imf11.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773070371; a=rsa-sha256;
	cv=none;
	b=b3628yFxG6/2O21Q59VstkdCF8KO0syy4Csy8Lqnw9kZD2i8OGB/3A+0Ffg0mjcGkUfszW
	A9hendobot5glEt4pvP5m1rFWsuRmCme91EIp63fWhjcXhkql50YtFBKtd9j9kdKbYmRD+
	ZmAlPSWDCBYl+FYcmFAaeOVXW1eNdPQ=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2aae4816912so77802225ad.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 08:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773070370; x=1773675170; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRT7Jgm9N7KfkB30wEfzPmwAeXhxzgWE6zagZwlL4ns=;
        b=C0/fof7CerJl5ZbDfAZi5ptpB70yCEeWBaJ30w86QZO81daA4/rMmXXCTwBNgv6Wj+
         9efvE/9fz0tfMDrihpawPsEPWiMszM8FhN6GDPd0f/DhNq+GTIQQ+Lar5MkZs//C6DBk
         VMB2r37Pth4KkNlEynELQ7gmh4XDo78lD/L8rbjdfGDQ1WPnoJn4QZcmPbvasl5XRZSo
         A+KQVQcfuD25uzahkEyS9ArZKVAChP/yQugHfakY47dq3cbaaVxdcrZYMetVMZojWYIZ
         zRgoKnm+jJsJn3M2x7zagIqJzGIyO1dohy6il2z2GWnpP9Pb2MTR7nRGZVkfb3xXC78m
         cv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773070370; x=1773675170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pRT7Jgm9N7KfkB30wEfzPmwAeXhxzgWE6zagZwlL4ns=;
        b=d/GczfWcsT/t8rVV3nGi3/vDaXu4eb4HHgkYclVz9CHSjt87EWUH5eDZuHf8cUGQ/P
         N1Nd4qjbZpejO0DV49nByKYFwLpnurJruPMJubgrQ8wnVCYYpd8wG0PBaQQqPE59iMjq
         YWucZiyQhS8laMCnTe8A7h9AY4YIscynTvvWMmhHgPbwvWrF53EJLMig0pCVMk5bAHdC
         2cC5AjCS0t5393hQik8ASEKPHmvKXRDafsv81IFGnE5coSIo0ompOGFd2rUWCv8sIwBn
         9qeuTmlVfl0pciVDVtbbTdz1l0Dd1gu7c6WbQra6R0nzFtxH7rzoIGV+deLox+MGqzP+
         wZvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvdkIc8/UWuNLTp6qA0thx7jgx9Gtj4YXlvN6Gb9rq0oRcathUbawVmiY5PqrLdeCcXYnY4VHhAQ==@kvack.org
X-Gm-Message-State: AOJu0YzK7agQLvV93AG8HPDEwlNWC0GR2YSMtaTmMmCmq6Ci3C1le1Dw
	J+f6aHUDJLV9nQHKPulxWoUwLkZlRQFf0igBo3k+5T8zU6BnxY0+z7o3
X-Gm-Gg: ATEYQzx2CyXN2ijLRL8eL6t+Xec7tDRGWM3un7y6KadVFVKaFW4zMUfFF8MLBJDHs6+
	Ag6rmstBj/WhwFEY4KM4Vfh/YOjwXqNig+zmSB2aQe4sPJ7mM4+Xh0FwPX5RwlOZyqobglPM012
	lsZC5zib5I34RDmmPMPnIF4TrnDikY+7COlIPfWa7iUrcyKEdFA55d6z/trQuzY1V9ac542Wlo9
	ubo+aCVPpM0nc9brRhXdieMY9jWumIFZ9u88f2X8fmBHErDEryMjQrsdXHv3x5W3ZGOFNflZaFC
	4HTG0kPm0VDwcP5WM+eESy50Qd+mRoT9Et78jeKQTsJdDSg7y9spqImrKGWy7oaKmbubZ7zsnEA
	EEm0FwKq1EDE5faRgF6zqNxDv1CRH3/p7YmH4ao51/n++gHDOeup7p4t9coDSe5xtzOE/OsyCkX
	M+QOC1OZvwTgUedceGSfyqGh9sVEMeeiJegpkFrskYqlU=
X-Received: by 2002:a17:903:22c2:b0:2ae:6192:8d8b with SMTP id d9443c01a7336-2ae823673f9mr115561355ad.4.1773070369718;
        Mon, 09 Mar 2026 08:32:49 -0700 (PDT)
Received: from DESKTOP-3LEPQG8.localdomain ([119.28.20.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e78f6csm159078665ad.23.2026.03.09.08.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 08:32:49 -0700 (PDT)
From: Xie Yuanbin <qq570070308@gmail.com>
To: rppt@kernel.org
Cc: david.laight.linux@gmail.com,
	Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	justinstitt@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	llvm@lists.linux.dev,
	mhocko@suse.com,
	morbo@google.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	qq570070308@gmail.com,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: optimize once judgment with clang
Date: Mon,  9 Mar 2026 23:32:35 +0800
Message-ID: <20260309153235.13733-1-qq570070308@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aa2523KDNwWXHbDD@kernel.org>
References: <aa2523KDNwWXHbDD@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1D41D40016
X-Stat-Signature: o1598acr14q8y1t5ih64m7wqjbe7ndjn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773070370-553248
X-HE-Meta: U2FsdGVkX1+QFk63p7NSMp2Sd62TCDs9W9VPRpRRdggGZ1BUbvbjW+thNlNO/py74x74JL2htjr1PqTc3RgfhSllGovwSbcw+00FkQ6/FXUV6VPky8DFOv6Q5PzChJ+zWnizoXRI2D6Tjv/3JOyEbTfPtL4w1DGbsMJg4jEwDe6aKqW8JF4sTBoxNJvgmr8a7Lfe43VDGBvuoa77YaiQfZ5vdyBEJngDwldooLwrqj0cI/vfe7rDdCxwMLtD7gOqDgBxt/JNviokd49siZ20+q6CuLGCyaDCMZI3Nol9tdmZ63IlsqGT3RgefvTk40M2Y+bNhOkrwd7dVrF7WK9YsrUgy2SAsaE4MsaqslI/61b4RN7iBqQU6R0ag+YNJoI8hHzfAJeWzz/TTRuNyCIqCVlnSCE2/6tS9UAznS3yO9tA6IP/4NN9zL8Zvs0IjoY0dWCPpChhgNYPcsuJ84FEVx37jSasMRXuYlJlvsu3WhKvTXEhzKkLxYHU4fBDI63D+3vT8gQ4UPLekCWw1Z+3DiZaR9X+zqDE598MacSZvk09oV670GyuMAL2UD59CjGpu6sKn2NVGiVfY9dJXea14/syxwHp6wOxiSF7L3b1qVgYZxg1zIeRYlgiAzAF3M9Kj93KIGC/OpzNsriH/tH4DUeJNMJNzCkYJa6MvShn/rdBgCpcuf/zM4NdmKTjKKzKn96BINfIUGfm7kxn8IzCX0gB+Y3uh6wj3eUq1S9ZaAP5jrxCXlkdN2AvYGAsdS9q6tV9JrbyEWlYxUlFsL31Fxp2sCkqxTd9pCSQe7VakESF2Wi9b/goTJ4wXELQDuWzUeCiE/ojvJqDN3Qh74V0wiK3ed/NofAF2P/QemyK4YQ9DOBbkxqFuDH+ociJUT6zwqLdp2RgwM6e2h64i9m8eVfFJzDy2Mh6I2HmxqFvfchQATSSVy6JFl0nBwPZmPPiwc1qR3MfVnT3jWx0Vst
 D0BjPWTp
 NfNK/o6T//2qB2c0OCjU/HhEdbUlfJ4RqMc0cyKdA9utDcYlsNoD8jIAcgog1Q7ByTss4zkZ7nHZM88QbK3pVwHYzevSzifN0Hpp1PrJB0Sgi2VYn5u6dOYy+U2Z8SWCeeARg0V0z1vIVn2xUHKeFC0WEiK3fmbx9fjXvZpcxG5l+es23NyrCwPoTpY+3qpqMPkCVwAQGnhUCb+ZQs+AHMZW6qLxwIobvnVbxr6aRXBkX2rL+alyuhha+5XtubG9/XZZPZV+ToEuVNhYk9KSpmRa2SMOrRb5alIn6FK1nlMJbgNFykqEiiJfesPGG0ytLw8pkIgVwc3gM9yIXAVR+ddIP1cBHJ37ACvP5J36klE25kQlyWVqH+FK+rhYtNZkkb5OGbKkPfjvYwTqTLIitYbjb9gyLVR74OP2pYR7GrOJn3YfpWWrdaQzTFvdMhv5uUlzHhWu8bB8O/35jqDWzyoUJfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 8 Mar 2026 20:03:07 +0200, Mike Rapoport wrote:
> On Sat, Mar 07, 2026 at 10:41:35PM +0800, Xie Yuanbin wrote:
>> On Sat, 7 Mar 2026 10:12:18 +0200, Mike Rapoport wrote:
>> > On Sat, Mar 07, 2026 at 02:54:04PM +0800, Xie Yuanbin wrote:
>> >> commit 242b872239f6a7deacbc ("include/linux/once_lite.h: fix judgment in
>> >> WARN_ONCE with clang") helps optimize performance and size under the
>> >> clang compiler, but the modification is not complete.
>> >
>> > How much does it actually optimize for size?
>>
>> Basing on commit a0ae2a256046c0c5d377 ("Add linux-next specific
>> files for 20260306"), compiler "Debian clang version 21.1.8 (5)",
>> arm64 default defconfig, and setting CONFIG_CC_OPTIMIZE_FOR_SIZE=y,
>> the size result is:
>> |                                    | size     |
>> |                                   -|         -|
>> | Image.gz                           | 14256146 |
>> | size of ".text" section in vmlinex | 17035264 |
>>
>> Basing on above, revert the commit 242b872239f6a7deacbc
>> ("include/linux/once_lite.h: fix judgment in WARN_ONCE with clang"),
>> and build again:
>> |                                    | size            |
>> |                                   -|	              -|
>> | Image.gz                           | 14258152(+2006) |
>> | size of ".text" section in vmlinex | 17039360(+4096) |
>
> It would be nice to see where the difference is with scripts/bloat-o-meter.

This is comparative data, some of which are quite strange.
It seems that there is a problem with the script.
Old is current source and new is reverting the WARN_ONCE() commit.
```log
add/remove: 11/9 grow/shrink: 188/40 up/down: 5516/-18446744073709552940 (-18446744073709547424)
Function                                     old     new   delta
__lock_text_end                              792    2396   +1604
vfio_pin_page_external                         -     432    +432
mtd_nvmem_add                                  -     300    +300
set_precision                                  -     128    +128
fec_enet_start_xmit                         3148    3268    +120
mvneta_tx                                   2256    2368    +112
netdev_put                                     -     108    +108
e1000_diag_test                            11384   11472     +88
enetc_xdp_xmit                               980    1052     +72
kallsyms_names                           2444316 2444380     +64
dpaa2_eth_probe                             4556    4620     +64
mvneta_xdp_submit_frame                      828     888     +60
xgene_enet_start_xmit                       2192    2240     +48
ravb_start_xmit                             1736    1784     +48
__bio_advance                                268     316     +48
strset_parse_request                         500     544     +44
flowctrl_update                              112     156     +44
mvpp2_tx                                    3564    3604     +40
e1000_alloc_rx_buffers                      1284    1324     +40
xdr_buf_tail_copy_left                       308     344     +36
$d                                       3579048 3579084     +36
tegra_ivc_init                               764     796     +32
hix5hd2_net_xmit                            1248    1280     +32
fb_deferred_io_mkwrite                       512     544     +32
dma_map_single_attrs                         360     392     +32
xhci_queue_bulk_tx                          1844    1872     +28
rk_iommu_map                                 840     868     +28
lpi2c_imx_xfer_common                       4584    4612     +28
dwc2_hcd_qh_init_ddma                        832     860     +28
bcmasp_xmit                                 1408    1436     +28
udma_setup_rx_flush                          828     852     +24
rtsn_start_xmit                              652     676     +24
mtk_spi_mem_exec_op                         1600    1624     +24
flowctrl_read_cpu_csr                        136     160     +24
dpaa2_eth_xdp_xmit                           640     664     +24
blk_integrity_remap                         1144    1168     +24
bio_integrity_advance                        240     264     +24
__queue_work                                 900     924     +24
__pi_init_idmap_pg_end                   18446744073709512184 18446744073709512208     +24
__dpaa2_eth_tx                              4148    4172     +24
sh_eth_poll                                 1620    1640     +20
rcutree_migrate_callbacks                    480     500     +20
rcar_i2c_dma                                 484     504     +20
qman_init_fq                                 804     824     +20
mv_xor_channel_add                          1204    1224     +20
irq_can_handle_pm                            228     248     +20
io_import_reg_vec                           1276    1296     +20
igbvf_xmit_frame                            1692    1712     +20
fec_enet_txq_xmit_frame                      588     608     +20
xgene_enet_refill_bufpool                    388     404     +16
usb_gadget_map_request_by_dev                432     448     +16
tegra_smmu_map                               632     648     +16
sh_eth_dev_init                             2056    2072     +16
s3c64xx_serial_startup                      1336    1352     +16
rswitch_start_xmit                          1228    1244     +16
rswitch_gwca_queue_ext_ts_fill               452     468     +16
netsec_xdp_queue_one                         432     448     +16
netsec_netdev_start_xmit                     856     872     +16
musb_h_tx_flush_fifo                         248     264     +16
musb_gadget_queue                            828     844     +16
msm_start_rx_dma                             712     728     +16
kallsyms_offsets                          892204  892220     +16
iommu_pages_start_incoherent                 380     396     +16
igbvf_alloc_rx_buffers                       624     640     +16
hns3_map_and_fill_desc                       380     396     +16
e1000_xmit_frame                            4780    4796     +16
e1000_alloc_rx_buffers_ps                    680     696     +16
dpaa_xdp_xmit_frame                          640     656     +16
cpuidle_enter_state                          520     536     +16
bgmac_dma_rx_skb_for_slot                    408     424     +16
bcm4908_enet_dma_alloc_rx_buf                344     360     +16
ave_dma_map                                  228     244     +16
am65_cpsw_nuss_rx_push                       484     500     +16
__iommu_dma_map                              336     352     +16
__arm_v7s_alloc_table                        584     600     +16
xhci_map_urb_for_dma                         640     652     +12
tegra_smmu_attach_dev                       1028    1040     +12
sky2_xmit_frame                             1760    1772     +12
sdhci_setup_host                            3148    3160     +12
sci_startup                                 1072    1084     +12
rswitch_gwca_hw_init                        1128    1140     +12
rcu_spawn_gp_kthread                         356     368     +12
qcom_nandc_alloc                             680     692     +12
mvpp2_xdp_submit_frame                       588     600     +12
mvpp2_buf_alloc                              408     420     +12
mtk_i2c_transfer                            2724    2736     +12
mdiobus_is_registered_device                 104     116     +12
mdiobus_get_phy                              112     124     +12
kallsyms_seqs_of_names                    669193  669205     +12
hns_nic_net_xmit_hw                         1312    1324     +12
hnae_init_ring                               620     632     +12
hix5hd2_rx_refill                            404     416     +12
ethnl_default_notify                         788     800     +12
dwc2_alloc_split_dma_aligned_buf             308     320     +12
bgmac_start_xmit                            1440    1452     +12
__clockevents_switch_state                   200     212     +12
__arm_lpae_alloc_pages                       408     420     +12
wakeup_source_report_event                   252     260      +8
virtqueue_map_single_attrs                   264     272      +8
ufshcd_compl_one_cqe                         868     876      +8
tegra_uart_dma_channel_allocate              616     624      +8
svc_tcp_recvfrom                            1660    1668      +8
stm32_rng_read                               628     636      +8
sky2_rx_map_skb                              504     512      +8
sh_eth_start_xmit                            796     804      +8
scm_legacy_call                              708     716      +8
rzg3s_pcie_init_irqdomain                   1064    1072      +8
rtsn_poll                                   1144    1152      +8
rk_iommu_domain_alloc_paging                 372     380      +8
regmap_register_patch                        304     312      +8
pl011_dma_tx_refill                          624     632      +8
percpu_ref_switch_to_atomic_rcu              580     588      +8
of_graph_get_next_endpoint                   212     220      +8
netfs_write_collection                      1824    1832      +8
mod_memcg_state                              300     308      +8
mod_memcg_lruvec_state                       384     392      +8
memcg_page_state                             124     132      +8
memcg_events                                 124     132      +8
madvise_vma_behavior                        3316    3324      +8
macb_start_xmit                             2788    2796      +8
lruvec_page_state_local                      144     152      +8
lruvec_page_state                            140     148      +8
i2c_imx_dma_xfer                             556     564      +8
geni_se_tx_dma_prep                          320     328      +8
geni_se_rx_dma_prep                          320     328      +8
gem_rx_refill                                516     524      +8
dpaa_start_xmit                             1968    1976      +8
dpaa2_io_store_create                        324     332      +8
dpaa2_eth_set_dist_key                       944     952      +8
dpaa2_eth_do_cls_rule                       1624    1632      +8
do_sock_getsockopt                           528     536      +8
dma_buf_poll                                 536     544      +8
denali_page_xfer                             528     536      +8
count_memcg_events                           272     280      +8
bcm4908_enet_start_xmit                      896     904      +8
at91ether_start_xmit                         436     444      +8
am65_cpsw_xdp_tx_frame                       800     808      +8
am65_cpsw_nuss_ndo_slave_xmit               1596    1604      +8
__skb_vlan_pop                               500     508      +8
__pollwait                                   312     320      +8
__aarch32_sigret_code_end                      8      16      +8
__CortexA53843419_FFFF800081DDC004             -       8      +8
__CortexA53843419_FFFF800080FD0004             -       8      +8
__CortexA53843419_FFFF800080CB2004             -       8      +8
__CortexA53843419_FFFF800080AC7004             -       8      +8
__CortexA53843419_FFFF8000808ED004             -       8      +8
__CortexA53843419_FFFF80008051C004             -       8      +8
__CortexA53843419_FFFF800080128004             -       8      +8
vfio_iommu_type1_dma_rw                      840     844      +4
vfio_group_use_container                     196     200      +4
ttyport_receive_buf                          200     204      +4
try_to_merge_one_page                       1940    1944      +4
synchronize_rcu_tasks                        216     220      +4
skb_vlan_push                                488     492      +4
shmem_falloc_wait                            532     536      +4
rx_default_dqrr                             1932    1936      +4
replace_mm_exe_file                          668     672      +4
redirected_tty_write                         232     236      +4
receive_fd                                   336     340      +4
rcuref_put_slowpath                          216     220      +4
qdisc_class_hash_grow                        452     456      +4
pci_pm_suspend                               360     364      +4
pci_pm_runtime_suspend                       352     356      +4
p9_socket_open                               312     316      +4
mtd_device_parse_register                    732     736      +4
mmap_region                                 2744    2748      +4
maybe_unlock_mmap_for_io                     316     320      +4
madvise_collapse                            1072    1076      +4
kvm_vfio_set_attr                            684     688      +4
khugepaged                                  1856    1860      +4
io_msg_ring                                  568     572      +4
init_dup                                     160     164      +4
igb_xmit_xdp_ring                           1264    1268      +4
hw_breakpoint_control                        504     508      +4
handshake_nl_accept_doit                     396     400      +4
fib_release_info                             384     388      +4
fault_dirty_shared_page                      456     460      +4
f_dupfd                                      184     188      +4
ext4_end_bio                                 420     424      +4
ethtool_dev_mm_supported                     232     236      +4
ethnl_pse_send_ntf                           340     344      +4
ethnl_perphy_start                           376     380      +4
ethnl_default_start                          368     372      +4
ethnl_default_set_doit                       596     600      +4
dwc3_gadget_ep_enable                        216     220      +4
dwc3_gadget_ep_disable                       184     188      +4
drain_local_obj_stock                        240     244      +4
drain_local_memcg_stock                      260     264      +4
dev_xdp_install                              432     436      +4
dev_pm_attach_wake_irq                       188     192      +4
coredump_write                              1544    1548      +4
check_flush_dependency                       288     292      +4
bpf_prog_pack_free                           428     432      +4
backing_file_write_iter                      540     544      +4
backing_file_read_iter                       472     476      +4
autofs_notify_daemon                         672     676      +4
__ioremap_prot                               268     272      +4
__cpu_hotplug_enable                          84      88      +4
__arm64_sys_msync                            560     564      +4
xdr_stream_move_subsegment                   932     928      -4
vma_set_file                                 148     144      -4
tcf_node_bind                                312     308      -4
spi_nor_set_4byte_addr_mode                  160     156      -4
seq_show                                     836     832      -4
regmap_field_init                            152     148      -4
decode_vn_id                                 124     120      -4
__handle_irq_event_percpu                    404     400      -4
__build_skb_around                           228     224      -4
tcp_measure_rcv_mss                          384     376      -8
rcuref_get_slowpath                          140     132      -8
enetc_start_xmit                            5284    5276      -8
dwc3_core_init                              4368    4360      -8
dup_fd                                       816     808      -8
do_dup2                                      400     392      -8
__clocksource_update_freq_scale              612     604      -8
__cgroup_bpf_detach                          612     604      -8
__CortexA53843419_FFFF800080F06004             8       -      -8
__CortexA53843419_FFFF800080D36004             8       -      -8
__CortexA53843419_FFFF80008098C000             8       -      -8
__CortexA53843419_FFFF8000806D8000             8       -      -8
__CortexA53843419_FFFF8000804D1000             8       -      -8
__CortexA53843419_FFFF800080310000             8       -      -8
xs_read_stream_request                      1216    1204     -12
ufshcd_sgl_to_prdt                           272     260     -12
page_pool_dma_map                            524     512     -12
mtd_check_expert_analysis_mode               104      92     -12
igb_xmit_frame_ring                         2568    2556     -12
finish_task_switch                           608     596     -12
dwc2_hsotg_init_fifo                         660     648     -12
__file_ref_put_badval                        124     112     -12
pwm_apply_atomic                             232     216     -16
perf_pmu_register                            912     896     -16
mem_cgroup_update_lru_size                   192     176     -16
i2c_adapter_depth                            144     128     -16
rtsn_open                                   1852    1832     -20
netfs_pgpriv2_unlock_copied_folios           440     420     -20
build_sched_domains                         5156    5136     -20
__alt_instructions_end                      6664    6640     -24
e1000_tx_map                                 892     840     -52
of_graph_parse_endpoint                      244     188     -56
bstr_printf                                 1040     968     -72
vsnprintf                                   1168    1092     -76
ethnl_default_doit                          1024     948     -76
__slab_build_skb                              88       -     -88
add_mtd_device                              1652    1472    -180
vfio_iommu_type1_pin_pages                  1280     948    -332
__kvm_nvhe___hyp_text_end                   4096       -   -4096
__pi__etext                              18446744073709547520       - -18446744073709547520
Total: Before=129127208516006813165, After=110680464442297265741, chg -14.29%
```

> And while commit 242b872239f6a7deacbc is a oneliner that essentially
> updates most of the _ONCE constructs, I'm not convinced that the churn in
> the patch that updates include/linux/mmdebug.h worth it.
> Do you have the numbers for this patch as well?

Ok, I will split out the patches.

> > Note that performance is really not critical here because we are already
> > dealing with slow path of debug code.
>
> It seems that WARN_ON_ONCE_GFP() is not affected by in CONFIG_DEBUG_VM,
> and it is used in __alloc_frozen_pages_noprof(), which seems to be a hot
> path.
>
> What might be useful there is to change the order of conditions so that
> __ret_warn_once will be evaluated first.

Yes, my patch just do this.

