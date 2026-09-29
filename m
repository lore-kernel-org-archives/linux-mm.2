Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BAD8CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 12:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51756B0088; Tue, 29 Sep 2026 08:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E026B6B008A; Tue, 29 Sep 2026 08:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18D06B008C; Tue, 29 Sep 2026 08:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF04F6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:50:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CE701604ED
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 12:50:40 +0000 (UTC)
X-FDA: 85266783840.08.C893119
Received: from mail-m1602365234.xmail.ntesmail.com (mail-m1602365234.xmail.ntesmail.com [160.236.52.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id F41594000C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 12:50:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=deepseek.com header.s=default header.b=XQeEEh97;
	spf=pass (imf11.hostedemail.com: domain of huang-jl@deepseek.com designates 160.236.52.34 as permitted sender) smtp.mailfrom=huang-jl@deepseek.com;
	dmarc=pass (policy=quarantine) header.from=deepseek.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790686238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4URAN5FNzJqUrmdB2RD2kXH3bcqOZ15omLjrDbZ/OsM=;
	b=ps8y9QFfT6ItQot+hwuw+JqJUgg6jD8wYgHgnfK2yWhVSFinbf6M1ucVtnuv/rSOR2k8Ro
	B1qbOrfoUSXst1uV644681Si+EuG19zU6ldVDekPiiP7oe20rm1q2ARANBQrMH8QlisIa5
	5NUfc/Rm/p+59CWkl4ianKKCtDMRzs0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=deepseek.com header.s=default header.b=XQeEEh97;
	spf=pass (imf11.hostedemail.com: domain of huang-jl@deepseek.com designates 160.236.52.34 as permitted sender) smtp.mailfrom=huang-jl@deepseek.com;
	dmarc=pass (policy=quarantine) header.from=deepseek.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790686238;
	b=t9G8S/jJFj9wM28tXGXNqC3zUVC9FE4li5BkOccHuhtXOmUojBhWO4czKd7Z7wNKlaxwr5
	W1qz4J9bet6hL1tou5imVI+sZ/zgNQmkHUAsgj4+vNGzpNkAnW4aE6cMAI4SZismJUmHhX
	+4uHU1ffaujaOl+683JiDr7WHEK4uig=
Received: from deepseek.com (unknown [61.164.44.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f8281338;
	Tue, 29 Sep 2026 20:50:31 +0800 (GMT+08:00)
From: Jialiang Huang <huang-jl@deepseek.com>
To: xiang@kernel.org
Cc: baohua@kernel.org,
	damon@lists.linux.dev,
	david@kernel.org,
	huang-jl@deepseek.com,
	kunwu.chan@gmail.com,
	lance.yang@linux.dev,
	lianux.mm@gmail.com,
	linux-mm@kvack.org,
	mst@redhat.com,
	ryncsn@gmail.com,
	sj@kernel.org,
	virtualization@lists.linux.dev,
	xueyuan.chen21@gmail.com
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Date: Tue, 29 Sep 2026 20:50:30 +0800
Message-ID: <20260929125030.1411980-1-huang-jl@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aruyFPzEe3pS_Qzx@XiangdeMacBook-Pro.local>
References: <aruyFPzEe3pS_Qzx@XiangdeMacBook-Pro.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0ed377a8e09cekunmd46573a965f4dd
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTx1DVhpKTE1IHhoaGE5CHlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTU9VT09VSk1JWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
DKIM-Signature: a=rsa-sha256;
	b=XQeEEh97ZWY5l5j1XqrZzUlvgTzY4NwurlzEV94OlooafpzLTNgVszlbD0jU9A7ekpsCD+3QqRz9T08bOYrlo/9DD7klOyalW5AYm0SzHoUr/5K5zjc2K4xpDJDY8Ka1NNnqDlD7N0xJcdf4J1YnZpmzQUzJg1l6eTlLoiGfvcI=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=4URAN5FNzJqUrmdB2RD2kXH3bcqOZ15omLjrDbZ/OsM=;
	h=date:mime-version:subject:message-id:from;
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F41594000C
X-Stat-Signature: zzpux6wwxxqpccchx9o5padyfsh51byf
X-Rspam-User: 
X-HE-Tag: 1790686236-409394
X-HE-Meta: U2FsdGVkX18jLIrJXQ6F/RiUf/KmNfLuIOHSl79mcwC/FNxWjeQE7gvtV0aePH0nUSiz0Ccq6/tO/bBBDK8mH28/SmdA3zhekgTqaaE8cYhWa9HD6Xt073D5VtBf6CDVRCe2ZZefP5OXkTIgP+4c369By6rY/tM34Dq2L2QHY57nDci9IGDIoQR7cNnoGPsugGuvPmDfQcA8myfyOMdNUaMlM+NzrYiIkRrJp5BxieP21aOXYxbBmZoH07wlrm1dhkyi2eljs2JIbY1cixFzlMTQdORi087QRYfM6Yz6mIgCFjcH1JXy3+n+JI2ubZUMA/KXLK1O9R/anbVyIS7pyd4NXn9f1RtrOjrkiJLGMTeuZegZAldqfVFBdgKQQCVPUsl8lxMNdmTtbow/xGJB7OE8qXjl9OOL1VAY60Lm9oveh0jVjY0qZWVahRdDafPHPFsT0saxR5r1jmdaX9KeV82GRHPRJc7jby/7clo/ykQIxOpr5nM+IpKiU9P6N05y/ai80NdRfKcOJCVEeIenOvQc12VB7DTlAGQ7HLiIiZlVB8lXzKJ/x78mwtcIVkzmUMtvKLl7e5j+hxzqC68TgJKO/wOaPUhEIfwRKSeWA0bX9GqwS7jHu009AG5FeJO9f/55qx3WZP2IbEy7QhCyFslolvD2O4HH9rbTiWdB4pNe07+cU16R1faSnIvd7fZqtJ3qmGSaOgl11CuRod1dQUTDpUU1hIKpbTIOC5l1KjDgrbkH04TqMtBL0dPTC18v5NFZQ1ER5CsaaWCgsT/hw1hMw+HtTbTTAkmxHd19KAtPq1LEAtsPU/X874923nBoDY7GjYIBRAZWmD88bTOePucuL0zIULA+V2BbweXgMRut22pjTxRTOwbkKhf6W+sED1TtehTXq0lsaG26wIVsPYeL4QvRW2Wgjv3H44aLw+AmJ+ub9nm4Kp9vOkosnL6iBPiuiZN++zW2rlHpArm
 scOueIGQ
 6FWD1fQ1nSOZlf31Yj/e9BjG87NwEi5+4hEHWpETs/qVgUfDXYbKNlhHQb79EPX9VC22T/wUxE6n5rZfx531SccQcnE46Azun9nWAUaqU3B9VPyyAeHzvLRAyCGITUTQpPPm/XzNfWoqXEGTxw+D4y9AJqavyhOQcJkoD4ad3lHfPRBCpt7bSjND4/VJYOt6zlnrze6uLudc9Jo6FEbeMoCb/Inmbp2a0v2NK5ixBsqz19xRhpscl6H4oX09HVnUKzw+7pGAXelF78oSIPB2pWfma+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Muchun's vmemmap work is also interesting to us. My understanding is
>> that it allocates private backing for struct page metadata on demand,
>> which could help reduce the upfront memory overhead for large images.
>
> Although I haven't had a chance and time to look into that, the main
> concern from me is that mmap() access will call
> "dax_fault_iter->vmemmap_materialize_page()", and malicious sandbox
> workloads (or not malicious, just valid mmap workloads) can cause guest
> memory OOMs due to "struct page balloon" for large rootfs in the worst
> cases and cause the follow-up mmap access failure, because the guest
> memory size may not even fulfill "struct page" for large rootfs.
>
> Thanks,
> Gao Xiang

Agreed, if a workload actually accesses a sufficiently large range of the
image, allocating struct page metadata on demand could indeed exhaust
guest memory.

Best,
Jialiang Huang

