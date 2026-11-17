Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12B99606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 04:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=iqedDka/
Received: by kanga.kvack.org (Postfix)
	id 069366B05B1; Mon, 16 Nov 2026 23:50:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019F46B05B2; Mon, 16 Nov 2026 23:50:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C196B05B3; Mon, 16 Nov 2026 23:50:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C01526B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:50:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBE6E1C36EC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:50:36 +0000 (UTC)
X-FDA: 85443385272.21.A7D5D1E
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id C0B8CC0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:50:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="iqedDka/";
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf10.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794891035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUYUZ2LlOsiIpdrbhk1wJZRY3ayR3Noi9TQPGtDKtP8=;
	b=rmDsorROJnd+TM1jhUsknSdeBFnWtehUj6Aex9MoycrBZ4WICuQYZ/rwQiD6nkJRnf+AdK
	+Zeql83NRh/iasMi/vhkX8yo8ngYxQv6pA8rHQlkL3asRZBwOWdBSfdSOBnUAw+uTK8Twe
	zubYFzP7o5IrIFY11C5fodEkR124aZQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="iqedDka/";
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf10.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794891035;
	b=gj8ikWQ1Lcgn9wA1rVZdxvWjmUOPWand35C7hCH4YXpi8SdBxCbBtzrEDXndlAnpAXn5Jr
	jY6jRhDbjIieATM9/V6vFegH+5lI3GPwrg7fHNzih+DWEmXiNH/OM9krVTlL6iMMwr1upq
	QD7qqon6uaKYJa+PJujDYOp1/7PBsvs=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-380b40312e2so2639926eec.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794891033; x=1795495833; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yUYUZ2LlOsiIpdrbhk1wJZRY3ayR3Noi9TQPGtDKtP8=;
        b=iqedDka/SYol0TVMkRRAC91Fos/yqygwjdzz13osHeYA4MXJeRLdbZ/UJnxnrHAGPG
         zp37JlgMr1XeGPSkULFi/3uTy3jYI47LFG3lg5gJ2twKmFIWfMes3pm3RTT0Lu4sPgBk
         0PmNoc9ZXdmp/QliE5UdI5J41/ayKKwxfHZUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794891033; x=1795495833;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yUYUZ2LlOsiIpdrbhk1wJZRY3ayR3Noi9TQPGtDKtP8=;
        b=PubtJZPSPdiRGQ45RWsnrgiHqa9X7gCesK4TDyiUmqdLLL0PCj34qlAJshw2S6sP9a
         9Y1J1UJcwyn3X74Hce+OSe95kVQLpfYRsB70e6k5Sc5cn/WXJIiDAjpM0PX3imhuegPr
         9TbNclK1RYe7simk2BLOVfXATSsPNHyDWk2cmjBueJstKvRNHeGfY7u++sAxHN1QV36E
         xKltWtzrrEwU2Zr9nVbI2u8fqj74kKQUIXQ208IRiYrOCz1PqFGTvuv616ZX9TDklSXe
         eS5HESiBU+0A9aECTt1OZnr78kO4po5bptmCs3o44FQPDELQsZeG9eYKaswkyWvtG+LX
         Fa+g==
X-Forwarded-Encrypted: i=1; AL+hErHJDcc89HmSumQUwk8I834a0QrVsaV30Gu9HTw9ZLCSNb/bZQGMKt2UJTktFV9PSmjTKGbjwxF0XA==@kvack.org
X-Gm-Message-State: APuU4Z8C+wN/odoFAFT+y/pA24hiYu/0ntG3lUdYljPztK1u+Nti2MPx
	qUmzkK2rwTxqMdrHFJQkiBGZki15uqVXWMW73ZxrtDNnVAVWqb95SHndZeuc8OHFCaQ=
X-Gm-Gg: AYBFou125wnLCpOqrJZiZyKesg5zSKoz2sbbD0Xl1xm7Er48I3PlWsUgODaPQLHzqcj
	Sk0lSbCB1l/r2S6VJd9TtVjm6wkwUTpuwsNUV9AXd5aPmqfng/czSIpE8sXLLwRIdgvnxOFCDZi
	IoIEBjCt96OBBAETo9cPk0GvQY+t0KWWOQiwYnfwHHWkFmjhy0o3HAiADFIHCRlfBSkFhoKBaT1
	p5N+e1BY1fjeJVu7qyOQ54IeozyWUs0Vmco2I5c/jzoZag737nQvGD7WsrD1xRlZpkZ9Pn9/OXv
	xD5GkzacMti+V1NlEIsf/JY/lNMccsgXFmMLWsKqSqxEtZDmQalLQS8WpB8fmv94vpzYv1pJwWX
	9ovu9er0J0kTcSFWaC1dPdkch18kXfi7T+nC6/r0W/w/7JsDa0/VjenNT2DXKdKC3owxkRcSDPb
	DJiX7Qv+xpY22XOp1PYWKmVgqNpDqaV8etBr0Tr6jpNohL2bC4OMdXwanjQUKVB3khJLwLy2qYp
	QthgjU3Oq2MolMPEYdkaZkthJUoVLwC3InOyrbre/y/iozLBQtuu+qH+7E5ACuB7LoYVEe6Lupf
	UrbshyiFZT1nqpkmaKAzmSGXNE1Cb5bwrAl2PmPL1u6nhRItT0zgf6L9rruq8SIyaT020Sbff9d
	b+BGirCLsOb3PL4TCW3Nd1PUGtsc+X/zFuTLU1JWJQXdioERc+JDqP6bvwJ/HUFiW407Tqdugun
	FEQCJqA7OVnlmsBX7kkpJ+c844TWUfpqrTVOkgouxMHvkFus7BlJQiloe0pP7D1GiS
X-Received: by 2002:a05:7022:1583:b0:1ac:1343:fa54 with SMTP id a92af1059eb24-1b503112a8cmr13989391c88.14.1794891033256;
        Mon, 16 Nov 2026 20:50:33 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm43375533c88.5.2026.11.16.20.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 20:50:32 -0800 (PST)
Date: Mon, 16 Nov 2026 20:50:28 -0800
From: Chris Down <chris@chrisdown.name>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: linmiaohe@huawei.com, muchun.song@linux.dev, nao.horiguchi@gmail.com,
	william.roche@oracle.com, ljs@kernel.org, vbabka@kernel.org,
	tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org,
	akpm@linux-foundation.org, osalvador@suse.de, rientjes@google.com,
	duenwen@google.com, jthoughton@google.com, jgg@nvidia.com, ankita@nvidia.com,
	peterx@redhat.com, sidhartha.kumar@oracle.com, ziy@nvidia.com,
	skhan@linuxfoundation.org, corbet@lwn.net, david@kernel.org,
	dave.hansen@linux.intel.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mm: memfd/hugetlb: memfd-based userspace HugeTLB
	MFR policy
In-Reply-To: <20261115160105.2507650-2-jiaqiyan@google.com>
References: <20261115160105.2507650-1-jiaqiyan@google.com>
	<20261115160105.2507650-2-jiaqiyan@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avvdFHtnw2BlE5Vq@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: uaz39et8idn4dwmam31xgoxggirjd7q3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C0B8CC0003
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794891034-149597
X-HE-Meta: U2FsdGVkX1+8KbYJsuIHRpm9/X+07SMPr2ASWqYNbiETwIdwdb6+wnqq99APdlQbusyjoVt0N1Po78L+ktjrg3Tz0RQVaGeSP2Zf59GrdmTCC1bMA39Zbg3qi/tyJhLLVpXnliwp5RTNukDgW6z/gvIQIMzcQaFgsg2woqQQv2EEQ8+SwH/id5KwpZPbslSBrW4hm7bWW6ORau/pwuNr9WNxGFl/mmeSROIHl45rDbxCDgDU1Bz2kj3isLB+0vn/S221ERK5/vo7wXgz8776PiUaWIrjOM2w3WldUzQfplzFOsaukFLaGtBqtmgpxX2oQfq8XnL9XscznQxkqtqnLlXE6G58Rd3AW15+0ATodiKpz5Cm5rg8AqTKogS3jnauswgCXgYFmy1lqwe51uSBvWizNH/B/GwYtwZpaGS1DLF6P1A/TG/Pm3NJ60u5CYOF/yLaOIzInhLVg4LQARs69fZlTxrexORmRpzAVaaFsbexmPLYes5EYuvRl+55Q9WCb0uyDKrcW+wPBNZiD76B49nnngOFX/NfTbB+jlKxdWnR6SbJIEMMEhn43SWunyxAlARmy0T4u+ZJ65GV5+Q+mnEBUR+sP+DZRJkt99UrMWhrIWXwryVwIXQcyoh3K4VvyNGlQwynQZQjyQt8Lo15k82tRrSMbfBAPUfUcJGtX5IA+kyGrfSRrQNMYH8W0BFUKOjH5OhHhj8RQHCVqb69QPhQ0KQoqWIonY5WJgjMU8eC/mDj6fjizo6j1qNCFAjvhxdVFxksggxd9YsR/sB+T/AmUJPxCYdkjxS7VBi0a1x/xhIO2M1mUqDFTYfoLbnDsX+cWUouepVcdjXtOxt8GTK5bzYecKX8LcEkGSqSic31fyF+ASeBBddRHEXgnPGucg2qfr4JpAIDtBz4dDaGv4TM+6l+LcvmAdHPT9BN7XjtWuvekgBri9SCi1UCI8QR8Lf6NpE+AvVf2/cIZyv
 1sa/JqI2
 b8dl3Eb4G29thrW5EmMz5eEoiKETxivEgaBROxocxtpnKN8O5qdGrfqs76yX47Wq81SpElzp9XBcmU66drXpEs5G+UhgshRE1U+XLggWHNDdSwT4LjBcVr7l7LtQ75WSgU8si5pM5NbLNHfFSzpnBWXdVtBFO9lSBH6YJxEDHVIhw/oZDSXDzKB1TXgOlxfoWz4fRw5/utWixl4e+ksvYB5jM+riuiWVUgYRNaHAbGNLOcH6ZEllz8U0t2866exySKSQ2MunwzU3Wj0GFnXyzskFshI0aCNM8j2i2Jqj+HInCAoAvIuLo7CtoJ8WnCXU+6mM9aAF3FmlBg4epKPPIfYN6BxziLV/V+EOyJ9gtfhxyd6rXlhomMxuZe5Z1XV0BSQYqHegozd9ssbW9fJCrSqLrWA2QlmBNYRh7062iBrHAexG+MqcJWfwkjWddHGcri6tgDmcCFf5mboeL4bbxQLEWKqfqLWbes2A7h/LmDACNc8cqvjph/BnCpbhgcWthG/b1nRre0YvhAehU2kqukuuxjuCf4q9HJTUF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jiaqi,

This generally looks reasonable in principle, but some comments.

Jiaqi Yan writes:
>+			if (!mapping_mf_keep_ue_mapped(mapping)) {
>+				ret = VM_FAULT_HWPOISON_LARGE |
>+				      VM_FAULT_SET_HINDEX(hstate_index(h));
>+				goto backout_unlocked;
>+			}

This doesn't look right to me. For example, hugetlb_mfill_atomic_pte() also
checks folio_test_hwpoison(), so UFFDIO_CONTINUE on such a folio still fails
with -EIO. Also, do_migrate_range() calls unmap_poisoned_folio() on any
mapped folio with HWPoison set, so offlining the memory block unmaps the
hugepage after all.

>+	folio_put(folio);
>+
>+	/* Refcount now should be zero and ready to dissolve folio. */
>+	ret = dissolve_free_hugetlb_folio(folio);
>+	if (ret)
>+		pr_err("failed to dissolve hugetlb folio: %d\n", ret);

This isn't a good idea when somebody else still holds a reference, such as
a long term pin from io_uring or iommufd (Jason was asking about the latter
in [1]). dissolve_free_hugetlb_folio() returns -EBUSY, and when that last
reference goes away later, free_huge_folio() puts the folio on the free list
with HWPoison still set. Now, while this sketchy page may well never be
handed out again, it is nevertheless counted in free_huge_pages, so a later
mmap() can end up getting its reservation against it, and as a result, a
SIGBUS when it faults. That seems like a real problem for a VMM with
passthrough devices.

I didn't check in detail, but since the folio has to be dissolved when its
last reference goes, wherever that happens, perhaps one way to fix this
would be to do it from free_huge_folio() instead, and treat a HWPoison folio
there much like a surplus one? That would cover the pinned case, and I think
it would also let you drop filemap_offline_hwpoison_folio() and the
folio_batch changes in remove_inode_hugepages() entirely.

>+		if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
>+			/* A new raw HWPoison page in a still mapped hugepage. */
>+			ret = MF_HUGETLB_IN_USED;

This also looks a little wrong, because a 2nd error now gets past here and
reaches the hwpoison_filter() check in try_memory_failure_hugetlb(), which
calls folio_clear_hugetlb_hwpoison() when the page is filtered. That clears
HWPoison for the whole folio, earlier errors included. I'd suggest instead
that it only undoes what this call added.

Thanks!

Chris

[1] https://lore.kernel.org/r/20250120172626.GO5556@nvidia.com

