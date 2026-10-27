Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD6B606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=H+3P8yQ3
Received: by kanga.kvack.org (Postfix)
	id 5DDB36B0843; Tue, 27 Oct 2026 12:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4B86B0845; Tue, 27 Oct 2026 12:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4606B0846; Tue, 27 Oct 2026 12:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF626B0843
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:37:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4DD880A4A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:37:47 +0000 (UTC)
X-FDA: 85368962574.29.3EE4E4F
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id DAEC6180003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:37:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=H+3P8yQ3;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf06.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.48 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793119065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZ6MRBphpDaEsaEkwyVS8b0WlKh787/wwfa+ssjtUBM=;
	b=2n31CEhkPnlWpLsD7srkdBq2/AocBCMMaV0vfaMUG01XhopmiLtwjiu7EUacc1CTDuuvpF
	hd1exdBMD6F3yb5y9IKAScjnndzWDI6w/Jb4wKDTgpK0rK86T29vYE+Rc9BmndYqkZbCeL
	K2Dnd1U8XVSjSBza+Vvvpqxv0hs2xh0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=H+3P8yQ3;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf06.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.48 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793119065;
	b=fp6VucFUey5XESEoIaqxN+Dd+WhahSVL70ETKnzAQ2RinU2PK0uiEyoBQY3QMgR934bCWl
	3v17KZkDUtI20ivazm+Ad5LG5i3qvqlAvFzQUayDerWo8++p0PZfhV26dIMmqvRqsjXokW
	Dal7btJnL+XGlMN/emnzGaNzKDmmcVo=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ae1d0caaedso42892a91.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793119065; x=1793723865; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=DZ6MRBphpDaEsaEkwyVS8b0WlKh787/wwfa+ssjtUBM=;
        b=H+3P8yQ3/dlhlw7gXKNTXBqbclzL66C9qSL5CDy1CziTc7izKlyF/xbiXM3G4i1QbX
         HbgD79LATIDkBtGdrIiv64slk15FixoK8yr0i1fygeDvNYZZQupan70R/pe/aFXwa+ea
         O+3AOQZ3J+cttXEzffVUXlAHbGNLNwvjqZUYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793119065; x=1793723865;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DZ6MRBphpDaEsaEkwyVS8b0WlKh787/wwfa+ssjtUBM=;
        b=2dpXjOr4wIv03iFF6geZFFa6uMqDqKbl87RtE1ZM/8k4QuMiUVsvlTb0vBPyBJdVci
         eLGvxMyR7sLRQa2ZaFHrAz/okfj+Jg0Zh/WUUt5fVHG0MXfM58rXttKF6HmdrDSs6GwZ
         bAdiyvUenjOik/tMyCH2kUV6l0CU5vleO55/vSGSR3QuZ86iYMOrHuesKIuyzcfRuGi5
         md97JTagweec6agWziUcjSxj5BrrkgRf5fbEFric7JZecXgAyEMVAN0xo03EGtbAKCMr
         nmcqW8HkNVw0h9XQoXLAgXYaYAmWldR9/aorafTsZtYmn74PBBHpiEH6Tx33xxu89Kha
         x+uA==
X-Forwarded-Encrypted: i=1; AKwUvByh6yWBVYMrp5dqHsJ9BWnZevZ7+2miKOxJVaHQqHsjS6iYSi+pPPPw+6Eck+r4vOV3XMcb29gOqA==@kvack.org
X-Gm-Message-State: AFq9FYJlEhWuKpbjPIA3DHwfUFVewo2AV6djarzI0cYmdYokPHrBAqAb
	xZY1MIcSfTXzUwg+Zh/yJCpxZDJMl0UwAvL02DtCEE25nEL9bAy2vyCljfzq/ce9FKU=
X-Gm-Gg: AYBFou2N9e2X94HkiOpGyaZvL4zE6ilaZYgL2lf40rbPOqSr/LFl755hl1k8SLnwTTF
	aK75SBxdz3wUkw7rKdJTpw9FozzvIXGSpVm1dB8fALZQoPWggKNapv11MS0j2YSiH+ARmss4MRf
	mz/RMogg9DK8+P2ZU6czVaT4NCR6OgtyiWfS0Ea9wF6cKd3bVBkcY9bPuVjc8IyrR35107s0AuN
	kWfFWyczQa9v8yy6FcFzZSXeZoAM+bv3QUESjIdENMh1ezuuHmKucJUwexV2+kbkddBB+H069cm
	2fpJaMUAsAsyl3dzKoE2aiwhljmyJ7tR5ry9W9fxqJwxReitP3HKKmCEa7CjzgbAU+E0/yiQfCt
	48zBx+KBj4QkKmsFES7IZicTXYOMjlFOpfU8uMZPOEkHhDl4Q9E8HRSMlGb/XqcGNXj5Ncm3xKK
	HGHVxv+64GU6Ir2NDQ1heaWfdl8Va/MuI7npRDJF+3enrlctDBTUKRCOTndA8lF/Fg1vb9LCojY
	MXaVCdYe79KLEA6fNMyG2/oNOPLKkw5aZk08GBawcs83tS7AeJ8NOufcBeXmf1oYa+zbRx1auEj
	kx6i5ShNesLuA8545XqtAsENctcSiyXPIrc7gXOjpreZ//whPYreCPZAk2ku8hQXJUUR8gD7KE/
	FN/pUx+N4OVwoKu/BAfZIrUQ=
X-Received: by 2002:a17:90b:4cc4:b0:3ac:b197:1a37 with SMTP id 98e67ed59e1d1-3ade9b2d399mr8594261a91.3.1793119064572;
        Tue, 27 Oct 2026 09:37:44 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4041fafcsm5635829a91.0.2026.10.27.09.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 09:37:43 -0700 (PDT)
Date: Wed, 28 Oct 2026 00:37:41 +0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>, Andrey Vagin <avagin@gmail.com>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/3] mseal sysmap: Allow with CHECKPOINT_RESTORE, default
 off
Message-ID: <auDTVShTfZ2et9m4@chrisdown.name>
References: <cover.1793094611.git.chris@chrisdown.name>
 <7ff59c2ab6c234ca4d799f862eb7c3f22d671f99.1793094611.git.chris@chrisdown.name>
 <auC7SFhV_qj-agQp@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <auC7SFhV_qj-agQp@gremlin>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DAEC6180003
X-Stat-Signature: zrwau9ieh78gfki79y8kg6wkfwnbqtxs
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793119065-990688
X-HE-Meta: U2FsdGVkX18bhR41G7NpaZ9f45o/D/lBGmkGJuiwT7qwj7PKjfP9WlISxu00TsgJgI8UsHdcapMfqHsOg8nCkU+CiU1LmAyiZpSSuDD2rrp8D9V2v1wk9HbDJbfTu1Oyp0bA4T0jgDY8H3N+ef+WZeLzVm1CeCDvYeYG7GI7UWBWEPysJtMph4B+BDIiXzxgLHUnZyKllB9UQqqHGn4tr5pas0izGGBTZF9WX80VCRpzIUbvu1rw6nFFh4QYgx29nvnfDajrx2C6rxat1wysVsijkg6w0HjxUHxz2ct5bJn0uSfpHw4T0U3QjoOFtRmJLbtBJBaGG9+uh1UGzik66GisoP8b4gWcbIjjvI2CDwh4K1FPKvUy7WRPQjB/3nmNW5AQr3I63BWHDGo26/1QO0wWegzD8c3wnrmUlPuFO+MBansgWXqFO1Kf/J+oZ8kscHZsG2kjNUDoecV2JZWN0XmXQieC2mQvCBNBHYylFnZLdK3teAMd8ZRZaiDpUoAc/OJGVZwyJMvehHmPUBqnBtv8lL18PmRrj9BitJ1m2+ipZnO4Oh68HLcphmTBex7gP+KApBsxtO3iDYJobgoZtq2snyuf0BoueAg1eN8Qf6uNLxR76K1XZbWBZCO3Bg6beaZqf/FM9MaVGD4dL7QXQJxSoHqgd3TwLpQmYH0imKIOcGzakHwqP+Q2sob5Y4RPG+NNTYIEhOIUf2IB+/xBorYdmZCoeJ8ldDDxmRxVjrfpTmHTqijpjYIrnEenxc32xYXD1PfG5DBkODwZNe0Q4z7/N3hVJs2DeLdSQSV2tGA9pOCc1ezQ9fSy+vBYq6s9MO6DiU5qBrDr+eP2FEahNypddk4q88zutoCSfHmY6b8Z2iG8CuI6NlI1TbDqJObqc7f/DYeM+R9A3TXkeM5psBLooJkcrnektvNegXoEersQzoXPOzhOVH2DgVhwTsUHGm2drbi0tUSuim/VYcE
 /J/BClg2
 LGCsQRumoP+sQ03RDMXCw4HSkJ0kwRDe2tfrzxfdTauajC0iB/KeHJNHo6pI8yJPJbX2e5s2fIM5zGVHAI2UklUsi8JQn/HsGt0QgwiBRZC0Y5LKLgdA4PukiJNKQY7AJGGA1gkuV/2i0ZuogczpO0TBdEVMyZxFbLwzHSsqE+D+6wH0uxWKpN5/l0zzGNhzEgDAIgxITKMc18uuJRq9ObKTvdk9Di/0Wk4oN/5NsjebWPn3DOIxD9jJeJhinn6MfNEl2IdVZ8Lq7ys783PTZ548MyQFWCYTLB7mO48GWLS0k5VdDGqG8HS0w3FfOF/NWAxJIVCFYsBx/9vRqTHaXbira1APtYZlCh5PhJ5hFJNIgKr3fgUJ1o6fQZP0499GrVOVGz9NWCjm4DOIShM0y1c3yUq3+HIWZDNlxSbxrrpmWyoAnrq+ARcv0IGFvdNfOMkGvKptvC/Bq452BdIrQqunlRaIWJ6gFC2phqbhmjw9djADfc4LiC80ye6IfS4bq1iSBnKh4Xz9wAgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Ok, sounds good. I'll drop MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON, and fold dropping 
the !CHECKPOINT_RESTORE dependency into the boot parameter patch. Thanks!

