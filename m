Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0742C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1256B00B3; Fri, 18 Sep 2026 20:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A33D6B00C0; Fri, 18 Sep 2026 20:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492E36B00C1; Fri, 18 Sep 2026 20:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 206ED6B00B3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:46:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEB4414014C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:46:42 +0000 (UTC)
X-FDA: 85228671444.08.F9D3E81
Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	by imf25.hostedemail.com (Postfix) with ESMTP id ED2C0A0004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:46:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z6deKx+O;
	spf=pass (imf25.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.40 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789778800;
	b=KV5+jxU+RmPNAzpmyNpUZPZcyBCZFtEQOffVP5qEHJ43390aJupOkyTcE6zbsO95hC2JHu
	4Al8DFjU0mbWaJYKBixPktWI+7PdiXaexwAulXl18aZv8s51fJBudIju3wj3Zdb/NWR2XF
	h3dJXU51JqmrTRyHFiXhrBXHm19Zf7Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z6deKx+O;
	spf=pass (imf25.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.40 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789778800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYflQONwlJSMZNXqCrxiR0VsKYk4eRcneht4Yn2HkRM=;
	b=QDIsj6fqvQWSZrLRfkz91EWA8sBewa+j4RcJGFZvDpeyWIQnvvkW3U/ReI1D2Zgk4xiMoB
	GvDBgoL4ToR31NFyE5llT0GATZWZenjJRzI+upGE+nvGEthEN2qe5RKA1YgsqYx8wzer4v
	me4b+RRBC+CFqvg17G/08+MOX6fsl6k=
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc5121bcf1aso1101649a12.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789778800; x=1790383600; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qYflQONwlJSMZNXqCrxiR0VsKYk4eRcneht4Yn2HkRM=;
        b=Z6deKx+O9DX8pn45YreRkWrW0QeTijdk/miHqaPEwm4YOdUZpUcUkeaPLMUYJVQ9R/
         ymmUED0o1qgS7kpa7FD5OOPojsk5kKG00IV65twIPzj9swArCdn/xNr8bvcofUzGJ9JB
         knzxglpdX5ZC+liPFWLAX4zfHL1YW9aiOnclmAh50HlPDSE5PN5QAatcBpaVikF4Vob3
         9aj+0aYqXxEGWk2YrQaaJKjbDS3iYc15hnLl9BT3XEbHsppo2Ikgmj55jPjk2xMdyp13
         PTAeoWs1s4SvyXkjGIq9EW+CZUdnl38qLARX0NbWcYkpv3UelFNJVw9FgelEtvd8ip+J
         qAPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789778800; x=1790383600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qYflQONwlJSMZNXqCrxiR0VsKYk4eRcneht4Yn2HkRM=;
        b=OFn2fQJ3oc7nvfJg84BbXxAuoisYQABlZ/3VLfaNpSbGZNNSAnk8PPu58HRcLxz3w1
         tBLxFaZr/7mrMQUL2VJe0VXTzPdd5Gz4i84VXv4cqWP9+HXDUDQeeBgkHl1Q3yhHAw8/
         SLdTIA95dcUCHB2UWorNmbx9y/037fnU/JzvuZ9dkthfrzIrl5aEt3VNIVNva5gi38oG
         snqtF5I/Q/qUaQyOiF83tKMDVrZpbgmE+eaxkUBwDCHpAKcxWF2WQuPZJA3hep5selp7
         7mkkO1lKQxk/h4DEc2Trg9NCcsN4ADZCM/epYc0hL/QlkK9Kh4htSJFpo27iYaihgP0i
         amxg==
X-Forwarded-Encrypted: i=1; AKwUvBxNy0Drg9jhSjwA12PEnSe1ClRXVScYyhRGFK1rLMZwy/V+BLrC6WT63D10cy4VPAIBaHGVjrx4VQ==@kvack.org
X-Gm-Message-State: AFuF++nkKOg8Ljuzl1GQRMuJKYZ45PYTI+jmUuxrfQUnNGNiM/j04eJ8
	O1otEiNTqodeODwi9gPX8R25ug3rQgJPIcq+fCljwXW3pUpG9KdCbrw=
X-Gm-Gg: AYBFou28CfTMLCcC7Be5S4lpmAtFAyjmfQPCpp8busk7t57AyR9EnPeNfKI4gzS3UdV
	6qYs+Y/jjibOThJQz/V9sBWGc8NRW4LFbsbAKPWoV+McMkiCSJpF1tzHaD+cTExOaS+jcq4HMWO
	vLIdAh0WdgeooXC8amFpxkne1yXGdgwZ7LYTg2eDsZVQevhNvQJFQqUWlL4rD11aRpNcgjhFS0A
	nW4mjS9NyKclHAG7H4z292uUhEjSbeGQVA73UxXOfUyyl8ejKV4T2ud2DQwmJNCp1RTlw/YYwqs
	UmLhdbqX0/ATBIRj1rz+MHUh9yh28dr2X0Uk6ytq9y65Gtt/ToHSI3MBrIkIuQ4VVi3n7/PO6cc
	IArpytt/guUze6JOk4f2ERaCmontZt4RNELvQMQLM3hjtHfwqxCI1BDF5JPp1lKUngEM60/f9ng
	D8DD97EMpL6aech7SFom9raSFSH/Png6yIDfSwLYL/yWLzY2BBIGoQHieMEOLDtConT7Cy8dPBk
	7x5xvPfZMSD7x2qCatE7E/Y/Y4=
X-Received: by 2002:a17:90b:2e0b:b0:39e:6c68:c78a with SMTP id 98e67ed59e1d1-39e6c68ca60mr1742297a91.64.1789778799727;
        Fri, 18 Sep 2026 17:46:39 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:45e5:9e39:6356:6164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c169dcdsm1927166a91.2.2026.09.18.17.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 17:46:39 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org
Cc: peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH v1 1/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Sat, 19 Sep 2026 09:46:29 +0900
Message-ID: <20260919004630.1159895-2-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260919004630.1159895-1-donggeunyoo.kernel@gmail.com>
References: <20260919004630.1159895-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED2C0A0004
X-Stat-Signature: w78n7713pthgq3c4iza379umfeab75f3
X-HE-Tag: 1789778800-11606
X-HE-Meta: U2FsdGVkX18kNIzDTY89Hen2mCoFwtw8Doxly0pqdyL4zOlhH8QVhwqc0fy9bPDZ1l8E44eJ87lGxuzmKtMkRiZbl/3lGgOdIFUZODV720pXsN/30TYQ2iN7YTA+JHLmCN1kF5SpexTQbeNkmKkMKjEoFzxZJW7cAKrQFekOgS38VTgM+QgzCHCYFtEtFKsrT4p6bIlE83bPDO0ePxkfAL+5uQbcDlyJRuWOy8ZbN08QOVfZ6OJmQC7tmFsM02ZZAGstzN7/+CAxw+qITMIbUfhJfSscKHhjYF8v0i/VjqFb4+KtC8305WsyZOAAOGjzf0WdBJ6b8ws6k+Ae6XjvWZTHpZyhpAka8rZvhL9tp6BNrrZptRvB/Je9QkeV72SzBhAfHBpSgAjRNlZ0X+/9bqu6UmZ6avEOwAPvtpY8Gfg696yZ8wnoEAPrwEZVNkXNHwCOdt5+nDGBuy0Toohs1um4sHyYq2KvqREWuR5vanfofJxZJScAw2UHYmA3ZIN5+j0nQo9iKciToYTxK6LxSXYUvDWZluMIHG1qMnL3G1AGjI9XBRadP2qQiAoLvHUcuVaCUKGcsUrMw6maA4ZHpofSlsS+PBaID6f600nZkhfHT/TGXyVimsFoB/cHLxlKdUsqb6OmthOxh519MA1KLdHzyZ2hpAzqlqgphZ82+YQdpZkPrbEHfnjbq42ht2szzjXjUi9h/c322pn+RdeUYiH+umKoIgvvmP+8+/8LBlgzJi/44JszUUaaZx70zHjrn5BX8+S6MwX/RYlt0wswyPJtPI4Mfvs4Ba5cKdfKduREZbaP8GELf0EF/vcMjOVo8xDm89fcznPY7hpV4tTNzJGpu7G9bOYnsQ+XHhQ3m/XdT/gjpF2EmordPTBKSg88xwjmYyz/sw5iIwroj18CH5p/qofh0bcJwaQ3s+42DO+5bUBnhj7eRtYcQQYYGeGkH872hgJlekZ2aDDQFAL
 ioFAWXgY
 01Hk4VBGN949P5DayZq99pgg2DO3/wZ8DfcmtCxuSibo0IRcQ8fSEYL9pjjey6Mj6iu3e5dbUm/X6hDxBFhqIw1x4PfSnz2pONFbUsWCe6faJ3P1PsW/UHlrT0fdoWP+JwD9XUnLEpD36mMgWLOF319pgMS0A10aXib4h/QLeuCMPAUJKIPlVZc01RDiXwNZ97+p/cTvGrei+VGCmwsvRWsqklOhWoocNWDNuzCKTRvVpriPLhamufr79DPtzwOHYbfYCAdmzwNA+z+ga/Ta5sHQxyA0Hz0nfFPIbTPV9NQ1G77YmZLs4qU0z4aO65iOaDDUKIJ17CS/TxEVWOnql6aksaHG/rq8VWq1plrEGZ0aXdLlY3JtpCJuCCXmVSP5M0aBKo5MGzvisOAi0pwKkuBE/tbaLqP9PEQIYhOkhPaghIJwwJrGAZ6ABGFw0ZZPDjiwhyMHp/ZWKl/x9vqEou0G8BPe+fxRu41NvQEPxaiagQs8sexlvtUyhuYJwt5/l/wYZigTNRJgLhW9LYsNwYL2+ds8QNtatXABPK9KlmHtZAzL8BP3xTdXFXWA3m6X9eRhb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFFDIO_MOVE on a swapped-out page installs the source PTE at the
destination unchanged, so a uffd bit set on the source lands in a
destination VMA that was never registered for write protection.  It is
then permanent: the bit is dropped only by change_protection() under
MM_CP_UFFD_{WP,RWP}_RESOLVE, which uffd_wp_range(), mrwprotect_range()
and userfaultfd_clear_vma() issue only for a VMA registered in that
mode.  pagemap reports the page as uffd-tracked, and MADV_COLLAPSE
refuses the range while the bit is set, because collapse_scan_pmd() is
strict about uffd on swap entries.

move_present_ptes() and move_zeropage_pte() build the destination PTE
from dst_vma->vm_page_prot and arm RWP only when dst_vma asks for it, so
the destination's own registration decides the result.  move_swap_pte()
copies the source PTE instead and only ever sets the bit, never clears
it, so one UFFDIO_MOVE behaves differently depending on whether the page
happened to be resident.

Clear the uffd bit on the moved swap entry unless the destination is
RWP-registered, as copy_nonpresent_pte() does where it installs a PTE
into a destination that may not be armed.  A WP-registered destination
stops inheriting the bit as well, which is already what it gets when the
moved page is resident.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Cc: <stable@vger.kernel.org>
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
 mm/userfaultfd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 74f04c323c50..6495666c596b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1452,6 +1452,8 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
 	if (userfaultfd_rwp(dst_vma))
 		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
+	else
+		orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-- 
2.53.0


