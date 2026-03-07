Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D077FC9EC3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 02:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E13F6B0005; Fri,  6 Mar 2026 21:40:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9386B0089; Fri,  6 Mar 2026 21:40:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB436B008A; Fri,  6 Mar 2026 21:40:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 345AF6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 21:40:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7D67C281A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 02:40:42 +0000 (UTC)
X-FDA: 84517713924.19.5A9BD41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2596340005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 02:40:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ferhLrld;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772851241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4ySrhmIAWVoueNJ0XFhaAcNVUvKWmQOTC3FXEXkHyY=;
	b=QX1Qyb6idIroN9fxVdd3X0aFMX0LAjLew/JUQlVn/le8Wkjv0+Z5kSXN1lSHwv2pyhMEoJ
	UOfISc7S2psuP56KTCT+ac4lxQjQdVPy34JO8flDdmPwX1Eg2fj02DVsY9EP7u0ltj/F+o
	mbfOJ+ERVi0hv1ZRmUhXhikc8iofbcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772851241; a=rsa-sha256;
	cv=none;
	b=hvxfmDBSNCaN/mfNZV4yGtW2hGM7mcJwQl2mbFe9chVdKIMZ/1Xm1h+MICwMZn2Jc8nGSl
	B2RSjlj3YhY1rZgHXw9kuHVtxk234CcWVXja3zyP5HNsdF1mvFNs01jpRBT2eNdTnLmxKV
	juX7USl9VVxoM4HdEOEdk0uMoBbwQK4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ferhLrld;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE6D240E24;
	Sat,  7 Mar 2026 02:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70760C4CEF7;
	Sat,  7 Mar 2026 02:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772851239;
	bh=VqI2kIRTJXcSdhafyI+w1IVbVYZZCzcxRnZsSstOUaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ferhLrld/gwQTRzDxSeIPiI1QMqpGlVrfPKpRtvO9Fz6qOa+gECS+KwgNbIeZZnbV
	 AO/5+XWo+JNgl5udjLqov9bg4iLOfFDnnbrGKIi0IUUaSnm9pvJWLqKQCn4n4Hn+6j
	 /+qh4e34uEzetoXDwT+clGAoobCzDga4Iynfj+GfREluKfs0Gm4tcllqmgYGuXSnOD
	 6SVAyCv7X6J42O0zgXpMm74LSEDRFa6ZuYkW3z2eeY4rvoIPGZi4hDxDEu90LVBZE9
	 6EKtFVjoUgRZdWA5DWu25knB+E54cs+ECjHckKgI3VLx3+8+3PQQSo2bddFh7523rL
	 K7pQzSoBtOzSw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 01/10] mm/damon/core: introduce damos_quota_goal_tuner
Date: Fri,  6 Mar 2026 18:40:31 -0800
Message-ID: <20260307024032.86777-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7sqwr7cj7dik67h7np8hau6ez9yykia5
X-Rspam-User: 
X-Rspamd-Queue-Id: 2596340005
X-Rspamd-Server: rspam12
X-HE-Tag: 1772851240-203400
X-HE-Meta: U2FsdGVkX1+y+h8QVRon52FfGIAtCv0XMztOtjNWRmNYBRoFBK0BcRJ4wdNJ3gT7UemN9aOZde9ofjxE0lnmtYIA3Twf5uvKLs0mi3mgw7KSSnVpxfp/x2vjSNMC9YlLAxYlqEy6LGdYH3+Sh1iznQEC5bjzWNVFB8iN5xEuT2hvGdXXfaj2v4sLucVgRZQTcF6aN3JlGfXFhjV9MFGF9lAJ551rdHOwnJ6lnJzQdn/+QNvN+BxEGxEmzLWgAqzkx6odYqmV/oMBTLOGCbMV8u+Odevt8gEIfpTxj7KEWwwvBpRmP9IPVvoAbhnFUPVhk/9j3d6490t2tcS1QN/0Iei2tRs12KK2hYKJjZEO4hf9HpodPHDPN0RIFwcEpdpNDm8zQtCmmTYw/8s7GWHP0aayVNqBZ+KhFlaZvXkkWRsrJ/CVQoZ5FeQYJXv289HVPz3YchLn1HtWRszSziCCIGhawof4U6zBKcmNheZz9BGLUhGef5Sb1Ia9mAQ6YiI69zsJ6ULT6gv5XEWWzI0lJj2fJ8EPTt9gcE/HtExpQY6nQ4YW5sn9rVOKBXkc3pw1pGasPZY862ficrqGtQ3rbo7+Rueh9d09m4kIpw6cYaJK+doUjPJLhekNAckrwPGIEhCq4q/jFDjNdVidWk/czWXj964IQi+hf17jHbpKV8K3G6pjlodsWU+bZNhaA6ZTDr9EytMDP79MdtMdczTEL9OjwpsRPscofO8l8GCSRgP3JPBzmGFO0MpXaSqPHMaouxnCDGYyyAOccGj5Fj+mfl9oDTwbX2u9ORy/G9tX+8To3YNarzVEHr4WfAqnZ8DJIJPpYRl1gmH/4tXvFhs78Jbd8yvMlr2dkbfoxZo6Z2UOIoHRFHcWvZUBzuQcAhEtVF3jIuzw023lVwCLFUO5HfQzc9QunqlT9vrcyfwDc6vy2fnFKwlkHfYoLHsIH7zuIkpLnCKL+fqufjanflx
 R5LWVZxc
 +vtHWZ71BHOuKhprp45x0m6hOuPwjAGYSGRCdpI4bD1wOhrVYAaSabyQ0Fw5ElWs2w8HDBen4+osPJEXVJfbTtTnd/mAOjZqnWDn0LfYy7QIkQxKX7h+N4zjsmYivhj6Wqh5hoA9UkD56Iyj1HZXnlg1mgEe6ImpqdT/lCbFhf/kMezwXVJH14RDpam/nF60RCNWVwYIxcLNMr8phbMJc3e4lQq1A80bhb0gqKk4sSB1H6CMNHgrVVZc3Zl75P/jcPf5Oy9DHMPETXSmYks2LWSl5niq7LspMZ8bxf7PWsEgvxKgjgTq8N1SEGerQcbH0HiEKhJt9bNZY7b0JskLhBOIKUpMQVy3MCDrArLMA1DNucx5HmTFWByn24yf+E3sdUNO0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  3 Mar 2026 20:41:10 -0800 SeongJae Park <sj@kernel.org> wrote:

> Currently DAMOS quota goal feature utilizes a single feedback loop based
> algorithm for automatic tuning of the effective quota.  It is useful in
> dynamic environments that operate systems with only kernels in the long
> term.  But, no one fits all.  It is not very easy to control in
> environments having more controlled characteristics and user-space
> control towers.  We actually got multiple reports [1,2] of use cases
> that the algorithm is not optimal.
> 
> Introduce a new field of 'struct damos_quotas', namely 'goal_tuner'.  It
> specifies what tuning algorithm the given scheme should use, and allows
> DAMON API callers to set it as they want.  Nonetheless, this commit
> introduces no new tuning algorithm but only the interface.  This commit
> hence makes no behavioral change.  A new algorithm will be added by the
> following commit.
> 
> [1] https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com
> [2] https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
[...]
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
[...]
>  /**
>   * struct damos_quota - Controls the aggressiveness of the given scheme.
>   * @reset_interval:	Charge reset interval in milliseconds.
> @@ -260,6 +268,7 @@ struct damos_quota {
>  	unsigned long ms;
>  	unsigned long sz;
>  	struct list_head goals;
> +	enum damos_quota_goal_tuner goal_tuner;

And the above change is not updating the kernel-doc comment of this struct.
I'll add that in the next spin.


Thanks,
SJ

[...]

