Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 931EFC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72028E001B; Thu, 28 Aug 2025 06:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C226E8E0001; Thu, 28 Aug 2025 06:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F848E001B; Thu, 28 Aug 2025 06:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7FBD8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:09:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B66985457
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:09:46 +0000 (UTC)
X-FDA: 83825744772.06.8DCB5EB
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 40E701A0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:09:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=T4ytG7n2;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756375784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxO8AVYywtt3WFeQdWxvD+biuxcMZ9Aq3qNXesryy44=;
	b=eZsteaWeIdR3iKtL5MtNLtmkey4wO7YWOg3aPnVXFglzzsJVmxGiWRVQ5T/ypYKeidbLXi
	3e7K0UCZPMJQs5kVI3GuKYBJ8QG3NqL+IvUBUCNBf/gYmgdhtmw8qzic6oAQZq8Y9RVgjT
	TMjM7HbOLtfN5KlNN0v49/aGQCl13y8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756375784; a=rsa-sha256;
	cv=none;
	b=6MKiHB9cDYG01Y2X2x4JxAfRYhrvDVkY5mhcu8EX5xJLajJei7TiCMBbvi0cnWigKdcU5E
	9Xzi8BGqeY/hkU15olFyHcnrv3GradHONag/Iwgzlho2BA3E8K19RPRJ1E2tHLO+4XeOMi
	YIwd3iK1ZM3QTFGe0Gaxci6BrgK4KRk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=T4ytG7n2;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3c51f015a1cso500003f8f.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756375783; x=1756980583; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UxO8AVYywtt3WFeQdWxvD+biuxcMZ9Aq3qNXesryy44=;
        b=T4ytG7n2Gs5ApvlD+UZaesQHmuN7jrvlTQ9GYUbn5T0ih5SJvRMuh3Ddj2gvRNHrAM
         V9mF0evbG8PeYmu6NNq6zq+b384OV1p7xaQrl1TXgIoAs7G5lIofaSMxysKUe/YZkUct
         p8tiVEptPzSAdVDPGAtZ7H1I5gmXtAFz2v8yGZlA1uGHh24DCa0YCPEv7VCHPGfI/Vzf
         yw6e1wLSRXJvJ/gi9FYX6DwVrpI11W5jSfPrjK63TiYAdRf+6hkmf5h4naE6SMm8f/sh
         EsDzVhhNG0HbbY0YvBBK8WoFiGTCEAdLxVMOMYH57lXIkKKJgz97jdajwDWg85lU5YOa
         Ak/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756375783; x=1756980583;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UxO8AVYywtt3WFeQdWxvD+biuxcMZ9Aq3qNXesryy44=;
        b=MfK4Q6ZKLnSrMdsoDDK+1sl6uicZz7ZVKJtpX1tayQ5sUkJQmankIXh3za7G/ol51H
         R4PPb8P85g2qmO9n/soQDNQLDQrq4TKFFqtvBVmM+7mrILrA7bPPLWFZ663kPATWY8RA
         1D1SOIqMO/KjQ/mBjaCtAy3cONszkWhIQdNHEAy+x630iHnJ/OWWfQoUK65UnEIXnVGK
         HOOM/88AOrxjbCD5XOsMjqdXTopeym5aB1l+v6A6cPTtAaY6V4zY5ARcZa0AWsvUnImt
         UOaNGXSHut/p4d9Q3s1Cp4PdH176fNlF2IJozr4KB1HFK4rCwjAYuhu74kRVAbCDYm07
         Uj8A==
X-Forwarded-Encrypted: i=1; AJvYcCVQkuW9kbUjctXicendsmE7Vh1CZ+dorjX1v20wJcpOvKn2/7sVoW/9z7KZ5KrrTs3s7FDHKRVOEw==@kvack.org
X-Gm-Message-State: AOJu0YyYOF3eCJ4YeYidocv6CpKMVbHZ5pRANsL3A+lPVAkg3TkphuHQ
	wG7Zf/fh3+Tm/lwBLR+rnhPrQxXP7t1ChbO+dy13r/AJOPmQpL6VEfTj53Rzo8w4bnk=
X-Gm-Gg: ASbGncsfbtBfdEzRE7tBLQqiLEo3EqdVZXODP3/DQeyoRoddirE9xc0gwC6xfPwmd1r
	rMx45D+1JVu9Fg/J/4M7VCALRwvJLPT+Vuf/J989/J9LUqZn4HfEU6TV+OZxExSBw/7hB6ISWtJ
	Fo5parRwueqUlEc4XSMVCjjDHbxBVgwnpwUEb0ibSi3qzd+FtrFXTPFDfk/4Qxpdjdmx0rFG9Fc
	4SPwAMc1GVCKiYljvG/RVa9ysrWXeGa4Pvo3KbgwetYd8GSQu2incshdCk6X/p3EhTSO3C0X1XM
	+mIsGOhEAVAN6fW1FYmN+9DuJ5CT369bvsruy1uz2GzMIVPRd7oBDQdue0uXkjbxbL765P0ZUnf
	E14oFB/vDOrP0k4dtGznkLThPtWjRPmuWoGJEegGIj0HKUXKt8GXN6tSz
X-Google-Smtp-Source: AGHT+IG1bgAvLO+S+tRFi0k2B+ex+LKH/y8F2ck7rpkxCTrTkkjnj8LahK98IeLP5+ayEiaJgPZMqw==
X-Received: by 2002:a05:6000:240e:b0:3c8:9bb6:ac42 with SMTP id ffacd0b85a97d-3c89bb6c170mr10721965f8f.32.1756375782585;
        Thu, 28 Aug 2025 03:09:42 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b6f0d32a2sm73554565e9.9.2025.08.28.03.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 03:09:42 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:09:41 +0200
From: Michal Hocko <mhocko@suse.com>
To: Weilin Tong <tongweilin@linux.alibaba.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-kernel@vger.kernel.org,
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH RFC] mm: Use pr_warn_once() for min_free_kbytes warning
Message-ID: <aLAq5TaqdR7GQB6J@tiehlicka>
References: <20250828030602.204332-1-tongweilin@linux.alibaba.com>
 <aK_7GKJ4BWjye4tZ@tiehlicka>
 <35e0a580-ae78-4485-b285-7f71f91e046d@linux.alibaba.com>
 <aLAj-itGT9DD3SU3@tiehlicka>
 <9639adfe-13ba-4c27-8ba6-8bf3e2190450@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9639adfe-13ba-4c27-8ba6-8bf3e2190450@linux.alibaba.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 40E701A0003
X-Stat-Signature: pn8ficdbdd7i6wjh65bnmxbbsukhnzmw
X-Rspam-User: 
X-HE-Tag: 1756375783-421981
X-HE-Meta: U2FsdGVkX1+pVVXkeNfmssTEfhtyCY62UDU1Fsn9ru+2qcd82KOBce5ArUBt2EGgzHQl4vxcpH6F1rcQWmfBOW3YX0KLbgy86FaWeJjkalRruNHGF2CoBr9WZK9iwvdClRCZeahswQs0ZaxDwolboUN3cFMQweU5L0JIKs7F2WUf+bii/l3i6ev8kmryCmhdzEOz2VjEMVWTWb7/oTp6ZKZbhZOnRlR6TJDHX90aAr9CMF9UoGpitd/cLK3PoQmr7BYaJbxotjBIe5k+3AIC7N5t+NA1IhKi261++JVzRTnOHV7839ZKRPh3ylBhlO9zTurMC3koW+TP0BN7MZspDPDUiqKjmzxf1v4GC5NdaimLYgZj1GRe2Vo2+ryCfxfXkREoC+w7glYqLk1JUrPvzRocBbCtB7tSkOQaJe1XGRD/nVkhcUvRl4mRwAiu5YQz0Tp5nJUQYCzBZWQCqvAiqZFpSAqZDKkKPumQKpdBEpjT0brdtJ8+NHHErbnTLV1B8IH4OOm6WhQT1NkSvA4aW22jAaQfYxLXuDiLgnugDuztcnr/WEZn1IEfgehsGeC1ceGdwrN9Ey1ENMuHHM220G70vmkzl3Xu6ctkYeYVq+g7PJneasljlVZow8jnJ5TRRZvFiihXdtEz/Bfh/jZ7AJ2TLVLlD5eE0nVvLWmBpknHKsnebUNbaMrXlaGAUZZCBI5re4H4G4qnn84UKvIeLNOiCi8q5SXDDaseNyfNHiKWKVOWBgjRg+wHhqdTNZEVD5MPLYAESrLTTQSdZd4V8GduckZlFTuw+nrs0ltQLgURiW3+nFymH9gK8ffoaEw/yqAhRj9n4cF5EC/YXn7g/QfAT9gFpdcZQsoLHnI3C6STPjzz9YzJ+CdRRhGKIsIYjyCMkGVaQszz096uAO1A+CKTthBLQ+TaoB2XC9wUW2oECPQVHnPFhFL2ZUR45FiB9dQEbpPQy1bfCzci/R0
 BXI2aIqb
 HAX/4GJNvCl6E7J/oUUajK6ejAsTj8U+ZVyXFBMMGLfahoX8kf/zEZ76lzfTzX0m+xUy1+ZHuQaPGkYgRFvb/aEIJImu0i72WPOrWEXKUnEMsaEZhLpts+lGbyMlXj+QV8C/VaD7YallUGiOAGER2CL9Ivx1J4hLHWprm+84+TDBzXI6gZLSMpTs2lSSDWdFkxgwVidvXU1RDA4akqTNnoJg67iPonhQVhOpXeAUnjWx8B22XayaCZI3/iMTpNs/Yww/mPiZEmc5DNYe1v8p4jtElJ4HUxEgHpq0iNYFTk+DdKNm97Wr7iZWOigZPqPYX812pAejoSSsi0HJDgjPIWR8afJFfKAIG3y4EnadrMwB3Ct9jgDnpHqGqbJOhZ5oOgv4r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 28-08-25 17:48:54, Weilin Tong wrote:
> 
> 在 2025/8/28 17:40, Michal Hocko 写道:
> > On Thu 28-08-25 17:23:40, Weilin Tong wrote:
> > > 在 2025/8/28 14:45, Michal Hocko 写道:
> > > 
> > > > On Thu 28-08-25 11:06:02, Weilin Tong wrote:
> > > > > When min_free_kbytes is user-configured, increasing system memory via memory
> > > > > hotplug may trigger multiple recalculations of min_free_kbytes. This results
> > > > > in excessive warning messages flooding the kernel log if several memory blocks
> > > > > are added in a short period.
> > > > > 
> > > > > Sample dmesg output before optimization:
> > > > > ...
> > > > > [ 1303.897214] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > > > [ 1303.960498] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > > > [ 1303.970116] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > > > [ 1303.979709] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > > > [ 1303.989254] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > > > [ 1303.999122] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > > > [ 1304.008644] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > > > [ 1304.018537] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > > > [ 1304.028054] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > > > [ 1304.037615] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > > > ...
> > > > > 
> > > > > Replace pr_warn() with pr_warn_once() to ensure only one warning is printed,
> > > > > preventing large volumes of repeated log entries and improving log readability.
> > > > pr_warn_once seems too aggressive as we could miss useful events. On the
> > > > other hand I agree that repeating the same message for each memory block
> > > > onlining is not really helpful. Would it make sense to only pr_warn when
> > > > new_min_free_kbytes differs from the previous one we have warned for?
> > > Thanks for your feedback!
> > > 
> > > The dmesg output above comes from hotplugging a large amount of memory into
> > > ZONE_MOVABLE, where new_min_free_kbytes does not actually change, resulting
> > > in repeated warnings with identical messages.
> > Yes, this is clear from the changelog
> > 
> > > However, if memory is hotplugged into ZONE_NORMAL (such as pmem-type
> > > memory), new_min_free_kbytes changes on each operation, so we still get a
> > > large number of warnings—even though the value is different each time.
> > We can check whether the value has changed considerably.
> > 
> > > If the concern is missing useful warnings, pr_warn_ratelimited() would be an
> > > acceptable alternative, as it can reduce log spam without completely
> > > suppressing potentially important messages. However I still think that
> > > printing the warning once is sufficient to alert the user about the
> > > overridden configuration, especially since this is not a particularly
> > > critical warning.
> > The thing is that kernel log buffer can easily overflow and you can lose
> > those messages over time, especially for system with a large uptime -
> > which is far from uncommon.
> > 
> > I am not entirely enthusiastic about rate limiting because that is time
> > rather than even driven. Anyway, if you can make ratelimiting work for
> > your usecase, then no objection from me but I would rather make the
> > reporting more useful than hack around it.
> 
> I agree with your suggestion.
> 
> With respect to your suggestion that “we can check whether the value has
> changed considerably” I would like to seek your advice on how to define what
> constitutes a significant change in this context. Do you have any
> recommended criteria or thresholds for determining when a difference in
> min_free_kbytes should trigger a warning?

No really. Certainly increasing min_free_kbytes by 1% would be barely
noticeable but 10% might show some difference. This will likely need to
be tuned on real life usecases so start with something and we can tune
that based on future usecases.

-- 
Michal Hocko
SUSE Labs

