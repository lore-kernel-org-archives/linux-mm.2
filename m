Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACE2E9D410
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8AC86B0005; Wed,  4 Feb 2026 11:35:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61EF6B009F; Wed,  4 Feb 2026 11:35:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E096B00A0; Wed,  4 Feb 2026 11:35:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 819E66B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:35:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B59F1B1A43
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:35:26 +0000 (UTC)
X-FDA: 84407324652.29.CF578B4
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2F9031C0008
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:35:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SQM+58Qt;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770222924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhkfFbUirjCOORCKvmyGc5UqbO6qlzQ7ndRt8aheA3c=;
	b=Db4nMvaBB/pZdUGhkl4SiRjDcR4BzNpXJEjqpYnF7HGzK8YzbEiUpNT8R763hbPG9A+xto
	xiDwy6DwstxmNHYRt+NQgxLIC7ho8p72HckhSUkLdMjYfCVWJUJiy96iW0AXzjOzq+MQWr
	sUq8vEpdgNncJ6vKSSF6mta3mCnklPs=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SQM+58Qt;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770222924; a=rsa-sha256;
	cv=pass;
	b=ovqBszBrUJ930+lRIPaPlp+kYHjwTISFutLJPxAjOsBODW6/A0j7+3ZO6dkK9LNdi/DUK0
	B7TqxgHRovH0dKunBH4G3cKh+/hYPV/H+oXiO6GUBs0fcI91EXR8PBQtdGv2iwMyFzZ3l/
	uwAuboxzU7A4GRmVjFvksdj/JRYZ/no=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50299648ae9so561631cf.1
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 08:35:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770222923; cv=none;
        d=google.com; s=arc-20240605;
        b=XlxtGNv5Ert11Scmg+Q/RYGjGEBEF8fphk3dVycPbfqdnl4RIWir3Qvv91j3f5Oh5T
         O2+4i+DD30QDzDo+w4W1ZsMSj8hGelU204Xa5H4RQMiTUxMC5h8cUcRU6+lfbTP1yzDb
         SoumVxEXmeOsa4EtMPKr9qHG/V0IzV5e8f6RBd69Y0MawTHKJMQPcsnCqo7uK57MdLgE
         NGh5ykdGVCfXajqpD6n7U99Ado3b+q0mIyXQy975KQDd91ctu0rDB08+ywy2aUgj5hrY
         cAkSESGTiBdSE8LEhgsBMHT/AboUQ0txtOnpJzyOLN2LDy6DmTlclipXqWw2KZzL8qVg
         A8LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KhkfFbUirjCOORCKvmyGc5UqbO6qlzQ7ndRt8aheA3c=;
        fh=RjjFBYQdH0b9FFbU2XBxxJDYBsSNXvTvf+f3Qp6BVwE=;
        b=AMqCbocaKO7kGjQT0xGu0GtU9qUrLZ0uRxKzYfmeH/4N29LKbBBVuXePU8mEJbPPLZ
         42Sid02PiStVWfuxFqPZPkMEt5c/8sBKgeFfTV2Mw7YoNXiMLd8K1eP0m60UFVOya4eT
         KFa3zzWQ+xDom8+9ZXo/xvKcGFAAqTJSuXDgDNxOOkezB5TijhqVFN4EbQlPlCPtto0m
         kyYtwZVwcgSFXTB7bo2UuTy2VTiRnbrB2qFIF8vhxl+4rL5+Vv8hVK08mQujgf3bd2oG
         8gHZvB7hT8dtH9JBwcUa5PbVJecgw4/C9fN7RZMkmR1l0APzd7Q3+F58qNjLGLlc5tnh
         ApYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770222923; x=1770827723; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KhkfFbUirjCOORCKvmyGc5UqbO6qlzQ7ndRt8aheA3c=;
        b=SQM+58QtC3L95fHQU9U3JVUHhf8GOHL1IpTzVv8CfbKiq0eYIPUN7MInK0KRFKr5Vd
         mDWbCJwpfeWTCmgE/zA6sarHRKNJ37rOjZa8qZr7NO9JwshiLOWYF/m9Gvm9+dAWSB5I
         7YmlAMWaACgTT5iirihen3pozjeappc7p6sdBbIHYlZdn+idev+arGNyJKQ6ipSViC/k
         oOCcdFEv60YEdnUw27NW2phiQzh2EdkFX/c8aNYb6i9+/O0ETYAschwY1RbOz53e8tY3
         jlBNYAzpczOMVRi2yJYDtxR6PYa642L4Dpnvj+VockiHuFoZubonDYhi5L9HR4cxITCj
         5Mfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770222923; x=1770827723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KhkfFbUirjCOORCKvmyGc5UqbO6qlzQ7ndRt8aheA3c=;
        b=wEuLRncTPEXRqVKfcTmLAvW1xGDplE7ElTxEyAGjtJLTog19JPC0gV36B96yu4B7ig
         WRF5ByTduscsAOLj02azy+JfoRZ9MaQJbMNtC+yEMsQpt4H7Z1+GGYcPrmxU06ifwo3E
         triYDKNaVQ7Yvsz020Sl87IMZU3h0pIneADADjVQe8AEjaeyJaRnO87Z984Jpkd0fyy8
         xe04cpKE3eVsPBQ/geFfee4O/WaVS83rocGMv7JaCKbPgz+6PDBgDjsLLCmIBpqH6szg
         0EXLqs5nY0BnWtUgyTxl5Jridf74P2cG/iRG0qWWd8ICfrruAz+EiRZiY2AQKKcVLLvQ
         xPqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWf/nzPcmEe5vwy9tNj7nhKQVYcPOpnqOKw7q5A1HHARM4E0QrdpRxoDm5E0k+66lJAK1HfxPEuzA==@kvack.org
X-Gm-Message-State: AOJu0YzFALmwX1gWm6eOgwC2msNs91/ZoW+2etfposI32RiMK8bTxj2X
	KTy/IpD0gsivqGjY+uxrZB10/bG/uRtI/E7/6NERK0hSmnRNjlAa94yMLoo9vH5DqFplQ4/q514
	JGnqiMM6P/51ia87UNp4iE8oQckqoDKnV/X+xv4+oCnputdZrcc0wojBCeZM=
X-Gm-Gg: AZuq6aLvI4wblC/fM6hwozaBkYtlD0OrJ+QB4DlCjcxZbqrpiJMZHvCc5i/0UPMS6VO
	8Lg1KTCYK7vKcPPMPi4pQlmfliwH1TbOiTuVIaEvKvUJ8cLhkesvG9XnotsqUqvwOaZMqSy5bdh
	SdWVZHedWTmvS3UJ3N3geqlIIVT+b6m/cERwjvJ2xdyNyGgjIg7JI0cSOiMlc1sncovKCinkq+5
	kPmGuvXNhaTsXoyHEysi4qOtH3t5Btt53hCpP/fgi3qfM+wqK9VG3/8wRFzprQGkaMZqcWol/Hz
	eBpIvBS1oWfsjziOV4J1j24Mrg==
X-Received: by 2002:ac8:5750:0:b0:4ed:a65c:88d0 with SMTP id
 d75a77b69052e-5061c3c6ed1mr14757091cf.6.1770222922649; Wed, 04 Feb 2026
 08:35:22 -0800 (PST)
MIME-Version: 1.0
References: <20260204101401.202762-1-hao.ge@linux.dev> <75a2obu7fk4t2h5wj54gkbtyie4pdenw4mzecmmsgzwbhvxfmy@7mrdfx5q5p3h>
 <51489c81-1adb-4582-8564-7c97b6a1060f@suse.cz>
In-Reply-To: <51489c81-1adb-4582-8564-7c97b6a1060f@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 4 Feb 2026 08:35:10 -0800
X-Gm-Features: AZwV_Qg7M-DAdVPiXc9bCptTyCrGd1STpnS6IpFDrXHTTXnMckHIpNcYuSSrUDk
Message-ID: <CAJuCfpGdOZhjdCdfyH2rn3o1AAx4J+ZoCyeNPX4TPMAGAv1+iA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/slab: Add alloc_tagging_slab_free_hook for memcg_alloc_abort_single
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Li <hao.li@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2F9031C0008
X-Stat-Signature: 9d1319kyxydrux7bpfqoiiff3s47jo1g
X-Rspam-User: 
X-HE-Tag: 1770222923-147103
X-HE-Meta: U2FsdGVkX1/sFxzNm0mJ+7bvsAwA7vzIoAkR4voVQGXmKiSwtI/Ez0EvX99fQUdJU7mSIp2aqMmmhokcVrqp9VO9QdxEB6j/DkG7Gx7Za2N2rEiyUs/o6hKItgQO0ebo0Lpv9M7pH68J6I9laVvoZBnr2iotEB+cvXI8YF+CArK1g248La8HcO/23zSTZ9wP5K2gD6Oc29mKNkoFKMZxiwJkUxGw1YFf7/ZACF+COw4okV/+iUcBM1H/SFs/FbNdaJ4C/iD581DNSlYhL1xcd0rGEZd3BOh/KjNG22YjHFIjT7kZzq1B+CzeBK+ziZutbRwAIon1wsmh+9oPBtK2uxEo+cEfEZQeXDEV5rQ9qGalUapUUnnDn7UWujP3BwPLQQmLkAYrj+CQPCthuNxef8jOpr4jIhQskaaaIi7yyXHEpdpcUS/nFV7xqmpR/BKtuxMeOs5KhmiWowRbj0YGIM4HlljGzOyzX2LjOST0X3UzxOGu0o1r2P8052n1pVpOWfkIP5uMtdztltezCNeX5UCPUByQ9D0XzVEKMyVR0QWOxVzzcYvlbMFb5zo5+++Q/EI6XyFKLqf4wf8QnQEAUF2GXl09MF6gGaNlMF+gvxtdL6xOT/yDR3rhHTNg4MFaWLz1f++Ovm/oYOMfqrbBDO3TsAaQ0wjwyM5f16O2eJj312YCGvcedz0k+fmfQwS3GTpUEzbF0PjjZJQPZjbgFEal13cDMuvEsR62nSmdE3XN/w+Uhbmh3K5B9J/9bqSq2AMogJgh4pNezE3V/xUwjlSNiOzxvsvEP/xaCRoqZlscrX+mcApsMCvAzxrVvlSd+gmgpXdLGTCsEd9BWcz3Rml/WkY6jg8qRia8WnP7DGOvEO3hWgpnpfa/wRmmPNoK7T/AUWyU4AkECcMeQtnd3QDmHVFuqbcTHWEFXZge4PlT96nh9E9ny976od8sVDvfRNn28tB29z7zoZGQxNW
 n//3pWv0
 0xFqN5+tm7YdYcsy2FthuDD25uyu6Uu62//FIju0I/p1h5dgJtkCSAWxgfvRHwloUKUyWl75jsjz0L9m9Uxmnehv/CJSAqSZb4FuXPt80MReJsinTUHwSn7olZlTjJzTbRvHIya8q2zrIGuRx+++T+MSOQ7BrYegs+BcJ+omedwpM25S7IdUTzunw9kvNdssg1TnrguOh00gYm8Ses8q50CnVJ1iBFKsyk/K+pT3cL5nxajtagpBMKH9rh7ymjcF83l13xnfKfVybw9LwogmSj+cvp1Z3CEJOjdRZusIIVaVIsXO2iYab6qdWlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 4, 2026 at 8:28=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> On 2/4/26 13:00, Hao Li wrote:
> > On Wed, Feb 04, 2026 at 06:14:01PM +0800, Hao Ge wrote:
> >> When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the following warnin=
g
> >> may be noticed:
> >>
> >> [ 3959.023862] ------------[ cut here ]------------
> >> [ 3959.023891] alloc_tag was not cleared (got tag for lib/xarray.c:378=
)
> >> [ 3959.023947] WARNING: ./include/linux/alloc_tag.h:155 at alloc_tag_a=
dd+0x128/0x178, CPU#6: mkfs.ntfs/113998
> >> [ 3959.023978] Modules linked in: dns_resolver tun brd overlay exfat b=
trfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel udp_=
tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse nfnetlink sr_=
mod virtio_gpu cdrom drm_client_lib virtio_dma_buf drm_shmem_helper drm_kms=
_helper ghash_ce drm sm4 backlight virtio_net net_failover virtio_scsi fail=
over virtio_console virtio_blk virtio_mmio dm_mirror dm_region_hash dm_log =
dm_multipath dm_mod i2c_dev aes_neon_bs aes_ce_blk [last unloaded: hwpoison=
_inject]
> >> [ 3959.024170] CPU: 6 UID: 0 PID: 113998 Comm: mkfs.ntfs Kdump: loaded=
 Tainted: G        W           6.19.0-rc7+ #7 PREEMPT(voluntary)
> >> [ 3959.024182] Tainted: [W]=3DWARN
> >> [ 3959.024186] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2=
/2/2022
> >> [ 3959.024192] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS B=
TYPE=3D--)
> >> [ 3959.024199] pc : alloc_tag_add+0x128/0x178
> >> [ 3959.024207] lr : alloc_tag_add+0x128/0x178
> >> [ 3959.024214] sp : ffff80008b696d60
> >> [ 3959.024219] x29: ffff80008b696d60 x28: 0000000000000000 x27: 000000=
0000000240
> >> [ 3959.024232] x26: 0000000000000000 x25: 0000000000000240 x24: ffff80=
0085d17860
> >> [ 3959.024245] x23: 0000000000402800 x22: ffff0000c0012dc0 x21: 000000=
00000002d0
> >> [ 3959.024257] x20: ffff0000e6ef3318 x19: ffff800085ae0410 x18: 000000=
0000000000
> >> [ 3959.024269] x17: 0000000000000000 x16: 0000000000000000 x15: 000000=
0000000000
> >> [ 3959.024281] x14: 0000000000000000 x13: 0000000000000001 x12: ffff60=
0064101293
> >> [ 3959.024292] x11: 1fffe00064101292 x10: ffff600064101292 x9 : dfff80=
0000000000
> >> [ 3959.024305] x8 : 00009fff9befed6e x7 : ffff000320809493 x6 : 000000=
0000000001
> >> [ 3959.024316] x5 : ffff000320809490 x4 : ffff600064101293 x3 : ffff80=
0080691838
> >> [ 3959.024328] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff00=
00d5bcd640
> >> [ 3959.024340] Call trace:
> >> [ 3959.024346]  alloc_tag_add+0x128/0x178 (P)
> >> [ 3959.024355]  __alloc_tagging_slab_alloc_hook+0x11c/0x1a8
> >> [ 3959.024362]  kmem_cache_alloc_lru_noprof+0x1b8/0x5e8
> >> [ 3959.024369]  xas_alloc+0x304/0x4f0
> >> [ 3959.024381]  xas_create+0x1e0/0x4a0
> >> [ 3959.024388]  xas_store+0x68/0xda8
> >> [ 3959.024395]  __filemap_add_folio+0x5b0/0xbd8
> >> [ 3959.024409]  filemap_add_folio+0x16c/0x7e0
> >> [ 3959.024416]  __filemap_get_folio_mpol+0x2dc/0x9e8
> >> [ 3959.024424]  iomap_get_folio+0xfc/0x180
> >> [ 3959.024435]  __iomap_get_folio+0x2f8/0x4b8
> >> [ 3959.024441]  iomap_write_begin+0x198/0xc18
> >> [ 3959.024448]  iomap_write_iter+0x2ec/0x8f8
> >> [ 3959.024454]  iomap_file_buffered_write+0x19c/0x290
> >> [ 3959.024461]  blkdev_write_iter+0x38c/0x978
> >> [ 3959.024470]  vfs_write+0x4d4/0x928
> >> [ 3959.024482]  ksys_write+0xfc/0x1f8
> >> [ 3959.024489]  __arm64_sys_write+0x74/0xb0
> >> [ 3959.024496]  invoke_syscall+0xd4/0x258
> >> [ 3959.024507]  el0_svc_common.constprop.0+0xb4/0x240
> >> [ 3959.024514]  do_el0_svc+0x48/0x68
> >> [ 3959.024520]  el0_svc+0x40/0xf8
> >> [ 3959.024526]  el0t_64_sync_handler+0xa0/0xe8
> >> [ 3959.024533]  el0t_64_sync+0x1ac/0x1b0
> >> [ 3959.024540] ---[ end trace 0000000000000000 ]---
> >>
> >> When __memcg_slab_post_alloc_hook() fails, there are two different
> >> free paths depending on whether size =3D=3D 1 or size !=3D 1. In the
> >> kmem_cache_free_bulk() path, we do call alloc_tagging_slab_free_hook()=
.
> >> However, in memcg_alloc_abort_single() we don't, the above warning wil=
l be
> >> triggered on the next allocation.
> >>
> >> Therefore, add alloc_tagging_slab_free_hook() to the
> >> memcg_alloc_abort_single() path.

Nice catch! Thanks for the fix.
Should we CC stable?

> >>
> >> Fixes: 9f9796b413d3 ("mm, slab: move memcg charging to post-alloc hook=
")
> >> Suggested-by: Hao Li <hao.li@linux.dev>
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> >> ---
> >> v2: Hao Li correctly pointed out the root cause of this problem.
> >>     Per his suggestion, this patch adds the missing hook call.
> >>     Many thanks to him for the thorough analysis.
> >> ---
> >>  mm/slub.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index f77b7407c51b..452a92544c6a 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -6689,6 +6689,8 @@ void slab_free(struct kmem_cache *s, struct slab=
 *slab, void *object,
> >>  static noinline
> >>  void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
> >>  {
> >> +    alloc_tagging_slab_free_hook(s, virt_to_slab(object), &object, 1)=
;
> >
> > LGTM.
> >
> > Minor nit: It would be cleaner to store the result of `virt_to_slab(obj=
ect)` in a local
> > variable and reuse it in the code that follows.
>
> Did that locally, also added Cc: stable
>
> > If you end up sending a v3, feel free to add:
> > Reviewed-by: Hao Li <hao.li@linux.dev>
>
> Pushed to slab/for-next-fixes, thanks!
>
> >
> >> +
> >>      if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), f=
alse)))
> >>              do_slab_free(s, virt_to_slab(object), object, object, 1, =
_RET_IP_);
> >>  }
> >> --
> >> 2.25.1
> >>
>
>

