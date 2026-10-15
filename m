Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53489CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82256B008A; Thu, 15 Oct 2026 12:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E327C6B008C; Thu, 15 Oct 2026 12:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D486F6B0095; Thu, 15 Oct 2026 12:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAA1F6B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:02:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 556D1C0356
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:02:29 +0000 (UTC)
X-FDA: 85325328018.08.0F92555
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6834AC0007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:02:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cW84XicR;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792080147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qp/9SKATs2UWKIBCgmjLLiq0NUYRNZM0vL2DioomkZ0=;
	b=eXIJM5Vc/zs8rcKZ4W43TBh3mJWCahcIQJQ2QpJh/fBP7odDorqqS5wy6a1GFcTqGjWEb3
	EadQz1pTQeJ79PI+Qji26SrAZo0YGcz80wTJx7JcwnL7fAnt+mWBNx+jE1M8cemMutRZ6s
	unpOiN68IFqcxAzyfHYxCpT60iv9jwc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792080147;
	b=l2cd0WAl0SR2gNQ9dFfet2kvrOomENt11t5cQ4QKMyfj/yxweNgZ+r+dtdHyi8WIwMiQss
	JhsYrbJxKjVCc9zi2CJakhlO4NwxP25YM3Tsc+LzlgK48cwu61Eljzegiw0NR21fTJ8lgB
	wDTL62fG2/1Z5lclZw2bLFlPywYnwR8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cW84XicR;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-917866225aaso75054636d6.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792080146; x=1792684946; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qp/9SKATs2UWKIBCgmjLLiq0NUYRNZM0vL2DioomkZ0=;
        b=cW84XicRbdyrwX+Jd6g37yXVTP3pdJaFsnbPm9Lp1J3fwFU3rUPqhU1QwSsqlckaje
         d3NhAGGbQAMJZ+mKOlsI+8CF65NCI0qJOmBNcnr2SD38qcpjjlc120UJYMxEGMpT/Ee0
         eS2CS9VtKEfrWaA9SZghvlaYIgECeogJGx6+Z2/DSkPa3wWTQohxTcvTESy930pH2wTw
         OJ17C2kvirUn0EI32c0JqnZfuQvck4xqar11FuM/3CBeQp1JaNtNhTeB4nHrKInUQWDA
         JOVmYhU+lGvpQXTktDiml+GQNHtAUXc7LdFxvKUAUftL5FSoCzwSCaGqQ1+Ef7Focd1s
         /Lug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792080146; x=1792684946;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qp/9SKATs2UWKIBCgmjLLiq0NUYRNZM0vL2DioomkZ0=;
        b=S8R+oRhABFXwP698lR/Wg2hgG4s0yPZAjWnTkotLb0mlck/livATCib8eA5lqKMCLc
         tSKIq2C4vMXyffd6CtlK3IWdfPCP2hQc1K+ZaMzNs2S3lYRlZBnF4PoxrQRfys0ax+zj
         rY22OTU5NvEmRjZflkFz9rYI6uf+siauWbcSL9bET5jKDCCWyXZ3D8fphprlS/M82w46
         eBd7vv9eD8JMwY7ihqFld8xWUKextoTxn/SzwBV7T345i4eOeyobD1tQojXQOUH4btUG
         IzE1MKuEbg/m42DWV94X2De5FT+1w2v2hJIuGXFDiRCt5zMnYiiHltlqvAkOTSc2DnK6
         jG5g==
X-Forwarded-Encrypted: i=1; AKwUvBw4Coh2c4KMhfKvlm5MN1mZHFIGxlDhsT1qti+flSUwBdr7CgXOaknxNmhtPCMXbwHXRLInwkSNqw==@kvack.org
X-Gm-Message-State: AFq9FYLRZGvFEbSjsCc1XVRHqFk45NpP1ClZVpJ4pU9gEmkaXxmuFsjp
	EEyJkV++MPwE3AcUG0Pu/85wUZ0y3wT4WPQChYb0cpspQG44NIgEMHK1g2Rs1GAiG/M=
X-Gm-Gg: AYBFou2I6UepRvOXMUHPodqeLAzEPmOAZ8IgIxG7qPlxuG29n7kT69VH9iBKnmdb+Id
	HzEZhwShfzAvdTI8LtQuEIzxWjzUV1074d9kJP40XhnfiI3+/VFhqzLIIFB9UJ8nvGuUwP3ck6d
	6PEA5tIZYb2XtnDcghLzTOIo6MbhucICTX3qXG4z8hZ11rAYByilIurvcMKSSqXMDg5lKq9kn1H
	DWO97LdX+EOrip9Zwm8sWZKyLCYpSbnTMDQ3yDTsmuqT1hPq+CQUKVOkoWclAyU1uRnx+TTD9Ln
	ywPl380H/9MupkKC4kNASMVpkOzcn7tzlEuOT4VdnOhWfPrvmAZnS0o0q44PWhkALmakSZxZiB5
	5806RQFaJPowlxQvv+h+/N9fs3uI25SWeOb2HogmW9rm8CmfS8lsXXGuE5NO70vqVdka/mzQ+VB
	/tLKfn5SzUUvMAlPGOruFLaQLBHlAhvu7myYM6JnDgnTJLvcJPSCB9Ch514hfTkUE+Q5WeWY9WZ
	xr9ciju5tfIk9XdLgqx+zmvhc14fsj/cHepA79A3F5tm0l7HCZF4wo=
X-Received: by 2002:ad4:4eeb:0:b0:914:5552:8a56 with SMTP id 6a1803df08f44-91b5533f620mr339928906d6.4.1792080146178;
        Thu, 15 Oct 2026 09:02:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b99ed3e9fsm78354316d6.29.2026.10.15.09.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 09:02:25 -0700 (PDT)
Date: Thu, 15 Oct 2026 12:02:23 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	joshua.hahnjy@gmail.com, ziy@nvidia.com, mingo@redhat.com, peterz@infradead.org, 
	mgorman@suse.de, riel@redhat.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, vschneid@redhat.com, kprateek.nayak@amd.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] sched/numa: fix scan-period adjustment for shared
 faults
Message-ID: <atD3qhbqzN2R9Bxx@gourry-fedora-PF4VCD3F>
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
 <20261014094347.99157-4-lizhe.67@bytedance.com>
 <as9_SwmLxAcTovnl@gourry-fedora-PF4VCD3F>
 <9b9e6c92-a291-48b4-a128-c31bc718db7a@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b9e6c92-a291-48b4-a128-c31bc718db7a@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6834AC0007
X-Stat-Signature: egyiukbyzme6849znxsnbyznsuwfokgy
X-HE-Tag: 1792080147-889864
X-HE-Meta: U2FsdGVkX18vQPIC7CK0tn6rBme+C8FnSb0il9rrijlG2uJ6zVanoSWpb2GJwsKLWhdl2QBJjgucLcGJ4/a8MChYnSNdBPViMuT5SO1apipTCHkHBU/2W/xXsFrmJD/6YJkdZu57FID2Jyk60WxPF5y10FRCRjsJFaFPcKHpvH0ggeXnZfUt7KA25TbmJg9JpZ1qZStsN0N31j/qzoRtn9ui8lPF25INjFfmOVmnmEgwX6ZAtU2a3NsRaxJJ8ZycVIAcLPem1a9cGAwH6mnHaGDQyCynhJd5V40fk1AzeplmxANiYoObqarA2O4jGhoucm+aehYXE7ZIn7kbbsGNtuDme5vBCnETgqoJ16jRRKK8hZNmUqlGHPadwe9O9NTL8iBrHkFOXbEhuXHrvThpIn5ODdk6+jKyBGujeK/67KkJRcx7EXST80PT/NF6bGoEk0QFfZxgiOgBOKiIAC6CoqSUTh7msWha36ykBqgtg9PD0WfvT9ophoHGHpQ6Yw6qzENnmmBBxuc9saQ86SqvJ5HBjZXqv5EbRNVGR+FGaVYbiNNwDb3din75ScNrp23wjwjFHSOvIWQFDVzffCu67iufkDTdDJvVnfVo61YdCuPUF9xRjEIHKl7Sld1yS/SBiOBuCjHWjnR+4uYBCoBYwuJ70JC8aLXFTsp44ZfzjijVaKW/0823QnBpu2sRy6sQbxywjlUmB069QLmRUbPa0LiFI41mE9rmTky4XatAKXb/68V4IPl9z2b7BWqvYnKNlgGsTCAmSRdgsp6F8UxVTNju9r/rv8bfOEkN/EZVp/K+M4fq7PSFa/51AW6OdLZeDTwTK7VnrVTQRX6hnMV/YJy2qt26YlplxUUoE5aJrx4sJGhiCj/iPOJIE0efGkAhadgi8IdvkhsOkRORwO841l+NTXyiHmr8MDGw8B27wwkODJriVFTVm2NvCEk87hzkEBG1r4OQ+8hLQArn0+J
 ryvyyglF
 RQvllMnoc3QvNmYfdeyqzFjV8NxDqH7k/Ya9qkhTVJEeOxFsQXr9caCDjsT6q89X3pGYwFE+OsdHKXMYla9xEl+qd/vL+PM8By5Lvs+v0VYtVQrRr+kkInq3gGS1MzVuloGM4pYwwL0g+TiPWOS+ozqytFMsx4zxjwGhCPfZ0jLHAv9xnKOi+/FOqlksb0VacjcBv6P/SLiWrTQwTyWSsZ3HexyZ2oENTrPgodTOd3xmQrua6DUGW8RXxK9/pc8wDklSUhWMRqfWB0SgMw9o0eD5+Z7yJvWGNj86m3KvLtCZgtsm2AZn0npLMW6F/kCfDZO3rQ03OaysFOjd0b7JuMokSwq/kBb6KO78uM1wqFYkGyKDHVmQ6mHIFIOq+QaAsj7eGpWCd9rtNz8F6T2IwFq+oeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 07:39:42PM +0800, Li Zhe wrote:
> So I think I should separate the severe fixes from the heuristic changes.

This would be appreciated.  The heuristic changes that aren't obvious
Fixes: should not be lumped in.

> For the latter, I will narrow the next version to NUMA balancing behavior
> that is specific to memory tiering, instead of trying to justify the
> changes as general improvements for normal NUMA balancing workloads.

For heuristic changes, please try to generate some kind of data that
demonstrate the behavior being changed. Some of this scan-period tweaking
is very difficult to understand how it will affect end-users without
examples.

There's risk of introducing unexpected regressions when we change these
heuristics.  For example - the recent shmem scanning fix.  Fixing that
resulted in 4-5 other regressions, despite being a "correctness" change.

~Gregory

