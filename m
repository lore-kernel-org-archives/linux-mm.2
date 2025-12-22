Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43C69E6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 06:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A821D6B0088; Mon, 22 Dec 2025 01:10:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05526B0089; Mon, 22 Dec 2025 01:10:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E75F6B008A; Mon, 22 Dec 2025 01:10:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AC516B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:10:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 176B460D45
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:10:08 +0000 (UTC)
X-FDA: 84246081696.19.9284084
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48096180008
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:10:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WnEsrUBU;
	spf=pass (imf16.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766383806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4d4yIf4cTLhpX8RECsjI9Ii+PJ5wkNjuQ9k20d0TZc4=;
	b=DIEl6Q2OF6wGVxtinWDJT1fmibABWcP6RRUdUc6X2KRaWYga7eQQQ+svM/iaOIuHvJ9l1+
	CDGo51aRWHnE5BEVqewchcXSjRgN1reQulZroQbcJqckpj2gD4I9e2sRsLkZrYjfOLwz8B
	vJcW+sxxwgzrxYzMzXpgBl9n8Dbx74I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766383806; a=rsa-sha256;
	cv=none;
	b=xAzMJaX0PLS3vMB8dWT6m7zgm1wLEwNqKR24LN3J1DCd0z5uRtMlrnC2gMrWYrLTAH7lfm
	jFd9HdOLd4y5oD4NNvHBJ8lWHo3s+Mo8eOYotWtIIfpT1QjR3L0Qe9rs09LqKo3GE111YQ
	fKlJp5q6+w9TpmJHFv3hg0QDRVMxUsE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WnEsrUBU;
	spf=pass (imf16.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a1462573caso461605ad.0
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766383805; x=1766988605; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4d4yIf4cTLhpX8RECsjI9Ii+PJ5wkNjuQ9k20d0TZc4=;
        b=WnEsrUBU5RcfOugUx990K0Csaqz6AqRT7WRXpvyOUyVq7TPR1jgRmB5TK89xQ0xwVN
         thmoXL8w2y2EEzbnyQVZ4lQHXhhFXfa6wVfp12gDeY17N/TDclVLIdOQxBugWl8kJ1oo
         kj1ycTRriXAv6Y1IQWGomml+MmU04aeSqqe3UcLdRVhvB82VmxjeRS3V5JA9O+MGsqcZ
         Z2RUgIGP/anJ9OYIX44iQ+VTiA4Zne13lfDqWLk6y5AfFGg9VW1bvQQedL7iDi4WDqwp
         1GSM61MSMKQ8hy9KgRvFjEjfmPu7UGmKPa/kt1c+LF0ja7i40wOrvLz9DFYiVhDqGixU
         yy0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766383805; x=1766988605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4d4yIf4cTLhpX8RECsjI9Ii+PJ5wkNjuQ9k20d0TZc4=;
        b=AHsi4RgN2ItiLhpWm5wRNb5WOmQxQa7DEDcLSY0kCLQJRzw2FCKHDtC+tHL5IKpf8+
         SnOFQDVyPuk/knCtg9YXR1uRboTCpB/VDG9fS5fiQnELpKvx6+Jk5+DQrevA1mX0yZjQ
         V7EE7gi8kNhK5Y36AAxF+a8rnNDGDrmpUgu0eXxQqwH1O+DBOoYxaE7eSXU9VxrmAiWS
         UWTaYy6lGPB0V1AmnS0hk37AZhmBMdXM0xq8Y2ly426+DWvYSjWhP32nTgOs91izeuxk
         q2m9C1kGtZZmheo6yJqphr+B/c3IOMeZoRo0L/BmewSQszammLn7mxtJoZ1Ka9OWZX8x
         jLNA==
X-Gm-Message-State: AOJu0Yzcwqstd2K5JGYCRxNxsBKa2LqrUswe5izMgzW+qQ6CPUuvpvT7
	R6JoN4V6xmot26rEa+K8teRQM+3xRE2tCLA8JfWeSLTx3B+mKsjakmYYsBf/Q4T4JA==
X-Gm-Gg: AY/fxX55TlFgBfmuu43LerRbrXIiuGMTi1uYieh25Aqbiwq3JNgK2YI7/rhJhNUyjmA
	CBJ9cXrgMMMjy5p9/TCNcwnH5wARKkhTZIEAkUoz3f+XQiaGJIkKpZvaip3a4UcwNUQPgbE40hd
	3LMRizkInTZ8zotsM+9yQNEormPNDY1qzZwVAjfgHxqfeaR/6kymsdA0ERK2YFXesktRV4RFvr1
	Loj8e200J83v10WWs7Br8OpoeO8rvXI6Vhp8l8DT/Sr1ekm6wG7VsaHixeovoceeTjC17J/K7yG
	oMnjQDj+GaY1/ngxxhFcmWpz7hwuI46Yhr3rmLGdJD5+yArG3qnrUyH4Ntdu7A4rk5uKaAFZdeb
	ege7IfwKxZkwH6LZBNh1K0zTIqM4FF6w3EbBR6sevIGEsVGZQWKvfjE/Q3xiXWKtViycoYEEx3Y
	mFs+OExqrNCXZ9HiPRAAxk/Gutyc2lxnT5OUsg3OXI8IcmpZQeLo6i
X-Google-Smtp-Source: AGHT+IGJHMHvQ2BiL8kGi+L1NEiyq9evaHsD0bUwM82dYISq+7N3XOj+vRLmNpWXWMhfzBHm5bRjRg==
X-Received: by 2002:a17:902:e788:b0:2a0:7fac:c031 with SMTP id d9443c01a7336-2a311806e37mr2693085ad.14.1766383804712;
        Sun, 21 Dec 2025 22:10:04 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e48f30bsm9091090b3a.48.2025.12.21.22.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 22:10:04 -0800 (PST)
Date: Mon, 22 Dec 2025 06:09:59 +0000
From: Bing Jiao <bingjiao@google.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, akpm@linux-foundation.org,
	gourry@gourry.net, longman@redhat.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/vmscan: check all allowed targets in
 can_demote()
Message-ID: <aUjgt4EdBv4UyrTM@google.com>
References: <20251220061022.2726028-1-bingjiao@google.com>
 <20251221233635.3761887-1-bingjiao@google.com>
 <20251221233635.3761887-3-bingjiao@google.com>
 <d5df710a-e0e1-4254-b58f-60ddc5adcbd5@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5df710a-e0e1-4254-b58f-60ddc5adcbd5@huaweicloud.com>
X-Stat-Signature: dqbrrzt6gy7t51ouxptm4dnjwtdniwue
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48096180008
X-Rspam-User: 
X-HE-Tag: 1766383806-132279
X-HE-Meta: U2FsdGVkX1/tue0lvsNnpKosTU3bhP5GgqlEfQmEcfKJsKP0YHdNEvp2ZdaRFi7t2htknN/A3ELycWRafKJruLN2Xwfpka+crmJUNX6YRr8gg+b7ztjK+WdyZTCuQDGr0LOvr4Q5DDLA4tzrf/LEXreqyoa0uWjJ8T8afzDpBXDSQw8u2JwNWSGlh19FKiiIMic4z2+cTG8aRB00fFzK2z5BT5IXZgqFoElMNq2mralgNrf0Hpb8IwUMa6Js4Py6g/poXl835zgo6iWFfkylA8s0pCN/DDfPhzN9jkUJqT8bujUH8loFSzp6LQ7XWMUr764NxvCRXTKUYJIWsIl40jyrMGTKYU2qHn2YbOZqa76hUq+vwhWI4SocIlWnrlJTYkCb6XD9f5AXdAQkZiTlRaPSi5VBNo/9/xQ3MbhyqvjNcgOvKGzeDI7WjhHxsvmUIBTfyj+FOJ4EPw+j9G5MUHRzCk4nD8DhoQaRSeSfKFql58pJ4VJRN8dmAYPnbnKl5LchADYRVwlRrqfXamUt6BvBtMGwTbDo9jHUV0tHmxuzLIhpyWCaUk5eW8h8vGjfdClUFpl19w2OPW/imUD+ORD+xlR03geD+8LTo1e7cPPS0aIq9wDnbvf6mS9+BjSzx0xgiQj13mckA8B19XrdUXpC76AuWZaGi4Runsq4QSierau/zuafeoUs8VlP4SCte0f/AcqcxiSN5jkmblGEgmGHl0nlgKDmy4sAWumw0OWW+LeuTAlXt4/4pyuIqCZwre6ABAboBlDYWFWSIs1ukWdOInajO04rDRgh5ymluqa/q3kJkmBe6a0ZyCb6v3PW9i50H2kaX1qrbB3XlLLYuYEthLWDCPFHbIy9BqrcX1BQvhdiK5l6TxReVW4u9t75OAD5If9DGONUFCc56YwmDMW5yN9VddkcspGLTaRUj99tRdwHUmBvm/q+Xxq86zEhLc4WtVL0bDO84GO4evW
 kBUqKgmq
 ZsHK+E5dJ9K3/1xlVPeQ++h3uVfyELmp9lrOx7ZjGwqE+I+Qi6CKXpznfE2ZoRqF+Tt0V3h2Gt45Zh5Up9QBS7q8h/+qHaEssNyufvxlJGJi9Ly1B0dejQFrWyGJzi+WqKxY+Y0f2Job22RZewG4fvB7mdCuSrLhUGJCloVdGCgERNkgqyZpcmxifcgrp8eITfk0CNbJBIoe6j+1V3+czBqB+GQP0D+ikls9L3GCkLVBAywX3xVOiuxN01GByJ6mLrrcdGhBYddBC8zBu1y6O37L6amlTXfhEDYNUnBcrjQLMaqZ7an/uzeK05z+2k4JYnwhQskzyRIriXSWtPWksFEv3YxnGksa31mwAXdOLaD1dY227q845fDQVQ6pMrqtgbNsVAT1vLlii/mEPtXJFkcWs1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 10:51:49AM +0800, Chen Ridong wrote:
>
>
> On 2025/12/22 7:36, Bing Jiao wrote:
> > -void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask)
> > -{
> > -	struct cgroup_subsys_state *css;
> > -	struct cpuset *cs;
> > -
> > -	if (!cpuset_v2())
> > -		return;
> > -
> > -	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
> > -	if (!css)
> > -		return;
> > -
> > -	/* Follows the same assumption in cpuset_node_allowed() */
> > -	cs = container_of(css, struct cpuset, css);
> >  	nodes_and(*mask, *mask, cs->effective_mems);
> >  	css_put(css);
> >  }
>
> Oh, I see you merged these two functions here.
>
> However, I think cpuset_get_mem_allowed would be more versatile in general use.
>
> You can then check whether the returned nodemask intersects with your target mask. In the future,
> there may be scenarios where users simply want to retrieve the effective masks directly.
>

Hi Ridong, thank you for the suggestions.

I agree that returning a nodemask would provide greater versatility.

I think cpuset_get_mem_allowed_relax() would be a better name,
since we do not need the locking and online mem guarantees
compared to an similar function cpuset_mems_allowed().

Best,
Bing

