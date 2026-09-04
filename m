Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3426C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCA356B0096; Fri,  4 Sep 2026 07:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7ACD6B009B; Fri,  4 Sep 2026 07:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90056B009D; Fri,  4 Sep 2026 07:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A03C96B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:37:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4118C1A0E04
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:37:18 +0000 (UTC)
X-FDA: 85175878956.10.652941D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B86E820002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:37:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWq7GcWu;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788521836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M35ChtJ6LeX4aN5jhdAT3A6U190niCHvw/nKaSgFqhI=;
	b=7fEsLKvYL+89/MYZA0L6/8oAlZcgp47WhVDDZmPG7c4HuDQfFQ5ZoQ7O2ELlyvHpfVQkix
	6LBjLb10jyY4/qnJyReOQN3y0XdQnk7BmUDM1HZuQDxy/Y3s/e7dAGJ0xnxjVRn6FzyeHl
	FToh7FAH+RoOFAVIHq95Rzlz+uqTI24=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788521836;
	b=JDz4vmFonBXodRQ2dYphogxHsafSIIFvBv6SOUhnz1aH1rwUNGeI3y2CQahExjnxIYyQOv
	X0T/O3MNag8k34EXy+AQ2BsbVhdSbkW3GmUDOIpgGvn10Y0T4JHMjxTXws4IHtvCLuO/mQ
	q1dgqjUsU9wwZ2Pt+3TG5MqqCbjNg+I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWq7GcWu;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41FA66020A;
	Fri,  4 Sep 2026 11:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12061F00A3D;
	Fri,  4 Sep 2026 11:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521836;
	bh=M35ChtJ6LeX4aN5jhdAT3A6U190niCHvw/nKaSgFqhI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KWq7GcWu3wYuI1i2MlTQzlbxBnc4tNFM/6s4h7dMYSE6I0N2cGP/fp7HPiIHQxh/H
	 vtVqJiRPDoR7if5qb8DFO534owlOw9gQXNo5zmU2dJ8HYRmZnhwEa58iPMZXzv9UE+
	 7eynM2QcakmyT8b76x4X1eZsQvet590ZDD1xjGxuiRcyLa7IJ3jC25g+rj/KMSLKYU
	 BgYDlNc9JiKrSR+XsIyxQfuLKilVh/ZuYOlobrkuieEesA2y5C1x3up434CncgWH2t
	 +zO+0dHkCCjJLpn4iIzDwNficQBNigwJK6akSlRwWqr+zvZhIjPcQ06WCBHOdzbcfv
	 kp+o+XibdDIww==
Date: Fri, 4 Sep 2026 12:37:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 5/5] tools/testing: fix typo "mergable" in comment
Message-ID: <apqtOmwcvDaA8cp9@gremlin>
References: <20260904104854.25272-1-hemanth.selam@gmail.com>
 <20260904104854.25272-6-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904104854.25272-6-hemanth.selam@gmail.com>
X-Stat-Signature: seh1k9a56zsdfzheuhmktmfriiqj7e88
X-Rspamd-Queue-Id: B86E820002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788521836-559588
X-HE-Meta: U2FsdGVkX1+5EuCCHpD0hS76hmK48rHMbxYgnFC2VyR6uvxf6kFRKkH8Sks157JX3gxcl2i0ubZc9lIKnwyU4exV0zGDnBwPQP9k77xG9kUeX6fSbd96L/UkRZPvX1dUCSLBJMKAkq/bvxA9aqTWT7IfiC86s7tdQT3k39IiD6wuQS03hMjLn1IRjtSIiXI57jfZKCWe0fyqZ2/jAOdoAyYVSR+jwYH3J9dmyygnXHaHQq7QBuCtwIIu2XZcQXoGydJu/Hn9Oab0Bv07FnwuLHWF5ZR+CnnTJrUOPwsgwtjJzuqQKlduNtLxox45Vu0AID+V1RCXazFRuxRjNk7blNRHwNskfoiOOT7cdOghAncK22tUXNHF/GKuiCD6AqzKLcQ4wLPZi/wy/ZsDOoDtGJFXGkvVu7CDbwGxCfg0nW1Ch1SAbEEhZyEhTihVXSlY9u0DHNAY354asJa4edWFlSle/3CjrZjcBHWqjC5fz/yo8NvQ77LNt7fL5EpWfCv/FqepyICOoo1OfoTHVwnrbYUjrgcGV2bVvEKyRRTfJRO9RFrGLWaZQlUiOybPWCm0Z8EaeiogkTWsX4UZzti7pFbzK467Nfr2RyQSElnqEPdDkpHO3uwoJkmdnpi6HZYpY1Ri2HDrTuBZWvxkMVEq2ljwWuyk1Nqz7AZqFYp1RynY0rJg/gs7kkHvY/jd3UeeRfZKIDS4aJbzrXSl+po2lu4JsAz6FXH3yymIjXpHsUB0NO478EUHM9DEWmRALfUYzmkji7nN65XCyoxC/Xu4PZ4/J35ossenR/Yh2Hk37zo5C8pBGWRVq/dKRl2+3yMGB4g39DekpHvsg8kHWTWfsecQO5V/ctp6XQGqr+j8XrM+gNG/c0KY/oR2mNFEP2JEewwTpKgiAKSCp3SEHbcrHaF/KmpC2O9JB02/KAviLm0fcy2KWEMxw0/wf5pr2a/rQdMSwU9fH1ldYEnvbke
 kkdzoElm
 idAZ59wPH2uXpUieNfdlEtH39f+FkgxREdvYoqQXrJByk/FSAwhmgQA+30oLGifciOmiG/5PDmXf6EuJxYyPPEV+gXMUBTtpkT412Lwj1O0vyiTmY2gRm8dlCPI40tsWsKzssY1/IM6FZhntKN87vinCq2F6XFeePSlwQJLuHru7KW9zyunA08V/6BPUYf+lPIIpcFl0Qe+EDXuXxfUWHMhZv7CMMNJWPO6tZwLswGGNpsphSAg4WFfXrAGBs9gfir79JwAtev7J4Hm1C74cup9skFYVJK9BOZzkfWux772zagS2Wv3BNs2u1UYeSvR6H7INFBGLjKdPXWm7ogehSp/qv4ZI50dEdFYPF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 04:18:50PM +0530, Hemanth Selam wrote:
> Correct "mergable" to "mergeable", reported by scripts/checkpatch.pl using
> the misspelling list in scripts/spelling.txt.  Only touches comments, no
> code changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

This one I'd drop, as a series of mine I'm going to send soon removes it from
the kernel altogether, and I don't want conflicts on a typo fix :)

Thanks!

> ---
>  tools/testing/vma/include/dup.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index 4c58487b764e..302a6774fca5 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -353,7 +353,7 @@ enum {
>  #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
>
>  /*
> - * Special vmas that are non-mergable, non-mlock()able.
> + * Special vmas that are non-mergeable, non-mlock()able.
>   */
>  #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
>
> --
> 2.48.1
>

--
Cheers, Lorenzo

