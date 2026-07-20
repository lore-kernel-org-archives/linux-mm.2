Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 227B9C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA55C6B0092; Mon, 20 Jul 2026 15:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7C2B6B0093; Mon, 20 Jul 2026 15:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB98D6B0095; Mon, 20 Jul 2026 15:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B05446B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:24:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 425901202B2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:24:19 +0000 (UTC)
X-FDA: 85010131038.06.76D8EF7
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf03.hostedemail.com (Postfix) with ESMTP id 816BD20007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:24:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cg+fxGp5;
	spf=pass (imf03.hostedemail.com: domain of 34HVeagcKCJ8OQ9SL9KFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--pratmal.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=34HVeagcKCJ8OQ9SL9KFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784575457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tr+RxyXd4dPtXqg+ZD5qRc7k0ZVs7iv7vU/1cWUVXKw=;
	b=HrFcBlvg8d1Oc80n8gPCidM6nCHgOz+rMTbA78dYhd+NUfoItr/fz43jn+r1HGRQvgNE0O
	vPNOt742XlXL03MCgPAZjzNFYRjum13Gtc47hD/m+B1C+t6KCP0hDR6FexqCfW2SESte5X
	Yva8F1cjnxpTcZ7ld/cFnrRM3WOTnWo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784575457;
	b=xrp69E/2bdnQB7wSx2jBVoIipu9tLNRsgQLf6Ce/SL/BfqFEb4hvZD8IjfmDxc0DMJgeYX
	xQrcOec01qFhoxYMCiVGqY7hzqlsMgkPLgaa/5JWtgGCkLRD3o6DuMJ16N1/wCand5XECN
	sIbum6BzDu+bINz9dUxZuJ8MU02K1vY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cg+fxGp5;
	spf=pass (imf03.hostedemail.com: domain of 34HVeagcKCJ8OQ9SL9KFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--pratmal.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=34HVeagcKCJ8OQ9SL9KFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e2f61c09dso6812553a91.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784575456; x=1785180256; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tr+RxyXd4dPtXqg+ZD5qRc7k0ZVs7iv7vU/1cWUVXKw=;
        b=cg+fxGp5JRb/JLnG9O4maLZ+tXGdDO+JOS77iUx9QD7o6MdVRmMywnvQJvG1zYNbtY
         5fbn57tqgMKIP7ICJw5KfaOFe9B25a3gtZwnBDUFTHHLC+LnSslLeHSLP9rkakAbxOcg
         HQmuxOI2lpWRaKy6s0GoloEEYfaAbjRaEL/j92wlHTku31Y/FfLNOWnmINGo8gDSrraz
         FsYDtB7Et2KjXDESc947u926qHwBaxUpwvtwSaM1rXjlgVCaTrHsaj1+gWhGG12jS7u/
         kSuEEL1fMrvvL23FZJtusGAul+lp0gNZRGfQ7kFooVbzi0eNj2Mlw3/l0XrEz7W7X6Ys
         zERQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784575456; x=1785180256;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tr+RxyXd4dPtXqg+ZD5qRc7k0ZVs7iv7vU/1cWUVXKw=;
        b=LsOSxcoipf/rcVwMi0EXf6GQkholPUaw/cZyr9BjJvukg8qmim4iLSXk3mMkRan26p
         qzrJsv+j6HFmdQwtx3WrpSwwWyFM6RdcCmsbZUhYYLrvnQ6SFjEkyVlSzKC+bG72uZRW
         Oxn+JNyrQ4K9oAToBWwf6yu6ecKX+8e4ed1Mma9RvXwqSgr6OJsZNpWh2Dusq7qCSove
         xNxn+jLf2RAblgJT2P79NQGdM8x6Uc0qGn5qBh07sgM1aW9F24A+KUZKFzJFHS8AYKQg
         MWgZLMn8UBUMtyW+0c6a3C013VCsaq5J1u6W449bJcUpYhDXC8zVrUXewhYJV701i6FM
         UZIw==
X-Forwarded-Encrypted: i=1; AHgh+RqFVh0Wrf5R4NnHzWroF8xo6NHmKX7JyNnD5hcvWUlcm0ZrO6DOi/tJKWrVcqCh65NnlYy/X+4GbA==@kvack.org
X-Gm-Message-State: AOJu0Yx1bjaBrxbrq5ccjjSJxRBAHx4Qp9kTXDllxIZ2gVgrc1buZ/wN
	NR0F/Tcm+vP+YhvnSP6D+3nrkwvUiFxFvuPfvchTB29T7/xTg4UKNPR3r22mMegisHdwfs93etM
	U2gKGtZH3wQ==
X-Received: from dlbqc12.prod.google.com ([2002:a05:7023:a8c:b0:13b:9778:570])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c885:b0:380:83fc:4315
 with SMTP id 98e67ed59e1d1-38e4b538938mr16800918a91.21.1784575456165; Mon, 20
 Jul 2026 12:24:16 -0700 (PDT)
Date: Mon, 20 Jul 2026 19:24:15 +0000
In-Reply-To: <03f6d16c-0f1c-4123-abb4-81a73eecaff1@arm.com>
Mime-Version: 1.0
References: <03f6d16c-0f1c-4123-abb4-81a73eecaff1@arm.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720192415.4060431-1-pratmal@google.com>
Subject: Re: [RFC PATCH] mm/page_reporting: Add page_reporting_delay sysctl
From: pratmal@google.com
To: Anshuman Khandual <anshuman.khandual@arm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: Greg Thelen <gthelen@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 816BD20007
X-Stat-Signature: ruay49wughskdyeyt3pb4szekuomkeek
X-Rspam-User: 
X-HE-Tag: 1784575457-853341
X-HE-Meta: U2FsdGVkX1/CRDjQOWA0Z8A2YuWSOQcEhU+0jlmuIC8sTZlkdaKyeM1VG1ZOqjhJw/OwmfPJ9TagjoOWzGnT7AGKXAj1aSdfgi2Y6fUweTzxo4JOL1BjnTvyzGIywnC6dHf/pDYaIHQ5x2r7VR8WDjhumraNsUj/qzp/lb9RSkUeVRl0FMMuJRQhs5rUQg9mOm822zCIaLevv8rgaWs2wRcraqcEwqhUB8cOnQWfox1RgapeNOnFY2Q3WXWuM6TCfnnSAx+iT5pRrV1Q0NfM0+zG0QLM80p9LO2QXYvSWn2tbBhRKFCDexN900KwkY7U/uTqXvUuIVFsGWiNz5gi5aQ+t/nz2WX9Ht7ajCo/24uvjD3BiCo9isSFuMxofmmf+UuqlJHRN+ZYI9ihQ5V4UxU4DwFJxPHgp5pt/Nf7VGTl3mLG2m/f+a3ZQUH5Wh4ApauJK2wbNQqyx2Mdeei2XNHU3PgaqKNZ6lLoj6SG+4LPBEgoyxe8HJeFwvF1H0ZweYOKs4Ccu8+RdrdEixdUA9DI3yvAn5Pxpp8wAaYTimzd5WF2VCJhDRUqq0EeTHEcyp3biuEv+Fjg3OhNPTtXJdhk6sJEXsq44blu1Wjmcfa35yo31YcIXm2UCzJHq8HyyH21FE/DWyqW6IKul8Twb5WFnHdAt9+JnZ8Z14TYw/ZshuPc0h8I5qaeAtpdgCCN+jWeUW0dIRDBsTPvH2GEBgLZz142zQHR017DKSk8HuVAgkljN/lOIBiRN86jXwEc7wM1ULmAYRJBa4w8QxZ9I/VxD/b1SL5mPh+9TKQJSdYuRV0yCOzxebt4Vpea1I6vpi8hFeS3JqxW6x31/gXCSla7yslYnDTKph23bCa8krTXXPdqdUqz8i/OY0GjyZf6utSY1jI88pWWMcZ/sJSpIAEO9C4aB+jOdJcjdQhNBPHTQw6W6CiTXTWsIkn+sBDadoTJWRRhfC1sVrJthM1
 4MCWhzQ9
 e7XeAKknHQW0bVkFXQgeTpMOTsZkbBXo3NvNTl6uePtOVzWbrFgtTHaTMZP/W/7UVxwK4t6FYzOBdBiH2zLSUU0/Vrd/ZEPrJ8z8EFJsPb9ZWiLwN1y445GGdBD0mVGwXgh/TCRTRYO+NOXLoP/pI0n8sXkRbG785WiP3cnMSSudFpFQUj0eRfW0xLz6Us2ScsWdMlQ2LgyCrs2yslWMteJcMfhR9lRb6LpsIx07bKa1ebkSLKU029va9m2d16O4gccTZmEKdX5KwT+mlUdyzjOZBxRkRhMlfJGb1Ayke1X9d+v3/PBiEorFwdIIi4dsfSjvaIHiuM9qpeEbA+nU2Lzsg6hd2s7hi571hb5q4HaeaqEYZxl02heuRr7qjt7V0wEgJADgeSFgeB7BWESDcs/M6ixM037haJPFvRUak4jCznFVyOcSLtt+l3/oAJ7CUonH783tgTQTc2hu3w06lBn7EF14LZ4cOx7SItVVtxXidlt5glkIuG/xvmEUywN4Kg4XEK7Qt+Vh7nosewHpEXSZg+0s/iQPRCSevJswizzgvw2WooZgPDYmSVAUqil+u1uzPtPP1MSAuGGVjsYfO9PGIBY/8XgVwaVfCl8QnP/q7cik7/QsigKNTb4Fw5xBqYGz4JAfv9ox+6SQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 02:41, Anshuman Khandual wrote:
> On 15/07/26 6:29 PM, David Hildenbrand (Arm) wrote:
>> -#define PAGE_REPORTING_DELAY	(2 * HZ)
>> -static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
>> -
>> Why are you moving that?
> 
> +1

I wanted the new definitions grouped together, and the sysctl handler has
to sit below the enum so it can see PAGE_REPORTING_REQUESTED. But that
only constrains where the handler goes, not the declaration. I'll leave
pr_dev_info where it was.

>> +static unsigned int page_reporting_delay = 2000;
>>
>> Maybe "2 * MSEC_PER_SEC;"
>>
>> Would we want to call that page_reporting_delay_ms to make it clearer what we
>> are dealing with?
> 
> +1

Agreed on both. I'll rename the sysctl to page_reporting_delay_ms as well
in v2.

>> +static int page_reporting_delay_sysctl(const struct ctl_table *table, int write,
>> +				       void *buffer, size_t *lenp, loff_t *ppos)
>>
>> We prefer two tabs here in MM land.

Thanks. Will fix this.

>> +	ret = proc_dointvec(table, write, buffer, lenp, ppos);
>> +	if (ret < 0 || !write)
>> +		return ret;
>>
>> Would we want to cap it at reasonable values?
> 
> Possibly with a macro PAGE_REPORTING_DELAY_MS_MAX or similar.

Yes. Will fix this in v2.

Will use  proc_douintvec_minmax() with a floor and a ceiling (using a 
new PAGE_REPORTING_DELAY_MS_MAX macro).

>> +	rcu_read_lock();
>> +	prdev = rcu_dereference(pr_dev_info);
>> +	if (prdev && atomic_read(&prdev->state) == PAGE_REPORTING_REQUESTED)
>> +		mod_delayed_work(...);
>> +	rcu_read_unlock();
>>
>> Is that really required? Seems unnecessary given that we expect something in the
>> range of a couple of seconds max.
> 
> Agreed.

Our use case is that the delay isn't static. A daemon in the guest watches
for host memory pressure and drops the delay to expedite reporting, then
raises it again once the pressure clears. The delay can be tens of seconds
when we're absorbing churn, so waiting out the current window defeats the
purpose of the dynamic adjustment. Apologies, I should have clarified this 
in the original commit message.

I'm happy to drop it or decouple this triggering behavior from the tuning
behavior. We could probably create a separate sysctl to manually trigger 
the reporting instead.

Thanks to both of you for the review.

Pratyush Mallick. 

