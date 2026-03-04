Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0118EEB7EB5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD436B0088; Wed,  4 Mar 2026 04:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B396B0089; Wed,  4 Mar 2026 04:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08DC76B008A; Wed,  4 Mar 2026 04:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EAF5A6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:38:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D7911B80D6
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:38:11 +0000 (UTC)
X-FDA: 84507879582.30.589ECEE
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id D40E1120010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:38:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lKgxNBFi;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772617089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fiJO/9et5qVDOSGM+mBfYqTF5/rX7jCVRCuOvkdHbvU=;
	b=yWoXpd1fl2p8tSZCcZi790UYl6mSc8ibNafx2inYBXFY9Z5QOV+Cu3ABznUmnkSMd2ZPGL
	ZsHfMfISgAORljRpHq4gnrmfLZh4wVX2FFV/VJEGkBtKvpirPpJd81BoIk9pJ0k31dJ0HH
	vIReGZNVIHCGUWHDJtmzZFVI15PKVUU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772617089; a=rsa-sha256;
	cv=none;
	b=6KexHYgsAm6f9SneKlJAnhL5FIfGixoLVFXBqBVX6qhwXxXjguTV8ZkODm7Oau5VxDV7qu
	fzZQnrjeBQorHuGrkknimWCuvF+qh+tlYRsnvCW5z0fverq5c3Tt7TzHDfE6mOByJ3C6ga
	cVbHTjAJhME6U6oz21NfQQQDUjNPO6I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lKgxNBFi;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ad9a9be502so44878485ad.0
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 01:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772617088; x=1773221888; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fiJO/9et5qVDOSGM+mBfYqTF5/rX7jCVRCuOvkdHbvU=;
        b=lKgxNBFiaWpSzjkXepVQacb5RFKdU37WArzUAGne4rl2CvsuKhpIzqkvyzG29cWUdR
         6ihu9CFgIMPcgawTleId3Zx5eqMUD8T+FzzvUvSaUhe8TW3qjP5b+kO0bLivjDosbzZr
         4VJ4zGQntPpkyKV5ot5U72YlpDZDC9Zhxu1EjIv3wWXZiSrBittyvVCiTDGzb7HVnepa
         URX5rKZUtTcphH516hkLV7s5W5F5xYDFUBujGUy0JrC3P2CQ7o75AIiWiqGfTKpeYBoS
         mZWNfVLNFPHpFYrEFuxIFcRpMIM61ywOdOUnL8FVivvF0vNCXlvHiUPIV/Z6l/zEE6xZ
         LQ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772617088; x=1773221888;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fiJO/9et5qVDOSGM+mBfYqTF5/rX7jCVRCuOvkdHbvU=;
        b=u6U/UnuHUpQM7KLflWP2GImJ/O+1Rx5V5ScZ4oX/eJ6PdyB32TNICb2mavIaFf61p1
         iazV+wsWgNXiBl/n1XK/vjgsNl5E07GPHXnAYPFGI0Pb4UnJ5+YIJaStaJzzqIOhNIw6
         CyAZANXvEZPAfHfTsA2H3Mb4YuvdbTem4brgcRfQsVsnbFks0ZqlEfP0I7ceQq4GfkL+
         vy9CBKBoG9NnxUn6cJMXMcpVD2EXactQ7NJB7s4IkqXzH2QGkZB3zF3MQ8Dxtbbq6sOC
         MaFAd5tFWWYWSnkZLELDnamWEj3o5FFh1KqnT0ozc8MceIN4R11Gyy81RlhB7G7QPR+t
         ak2w==
X-Gm-Message-State: AOJu0YygAI9tlUNS1Val0XiMmn/IzR1RMkr6AmAzZxxoO64AEmv5zqFk
	31H7PtKlKEifATV8we7O9bAg5hNyL+lABzWEtglFn+NIEk9AlC2DL/jg
X-Gm-Gg: ATEYQzy2seEAFTMSM1eetlfZBKPhZoeFhYl0Zq2QNSPXhUUXXiOJwAWlbcPhygF/XVW
	s0UZxn1deApR5R4J9qhoE4hn+4tFR20Q95wwEnuJNrC0GOKhdVpcaPaVE06q4Qm5wlmGg8pe9A8
	XX15tQT6od4tkos8IkOUk9Vw7CtFqk4rG8KEKtqiPzEP/ezStTLh0qMVvadrNaslVXRa5lZh/Hq
	uy8yOXzhIGn03I/7p/Mm/as/3M5ewRZbrHcvLr3S0Y8giFVhasi0Ijxc0b/8DkgS40AmFlK1SW3
	6ZY5MRfFCC7XjD7OgvaZDmY6Ls9gaqvYMzXrBR3wS8QB4vTXL4H0y0xZ1DKJSGmcUwEX+5bfq8/
	+SYrBm180EurRkEvgm4mz0/GL9jwIfAKOf2ay9fv7+k7Hr9LxbWarNXGbA/OyXwuq11GzZE2ten
	xazqkAPJzbXTNrBltC
X-Received: by 2002:a17:902:da4d:b0:2ae:593c:48fe with SMTP id d9443c01a7336-2ae6aa06a22mr11815955ad.13.1772617088564;
        Wed, 04 Mar 2026 01:38:08 -0800 (PST)
Received: from dw-tp ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69fa65sm190048445ad.58.2026.03.04.01.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 01:38:07 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [RFC v1 10/10] powerpc: Add MMU_FTRS_POSSIBLE & MMU_FTRS_ALWAYS
In-Reply-To: <727cad61-9df9-473b-9a79-f70ad1cd4e3e@kernel.org>
Date: Wed, 04 Mar 2026 14:53:49 +0530
Message-ID: <87ikbcj6ca.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com> <c57b1c00145a2db1a1b4feec94cfc2917e4877af.1772013273.git.ritesh.list@gmail.com> <727cad61-9df9-473b-9a79-f70ad1cd4e3e@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D40E1120010
X-Stat-Signature: abx7uhfjmnw9wso4sxumsrkhuznauheu
X-Rspam-User: 
X-HE-Tag: 1772617089-822965
X-HE-Meta: U2FsdGVkX19MMEpqQ83wOCz91osyx6K7RZVdPStifWH9FMEIyHHxt/uw1WmH7dG+tVbbTS5cb73MklsNqt7SBWY5asS7M3BzH3hLLYhXKGuUVoL6hnG4lBnYnC3vEu9xnjuSUB7qx8a1gMftQ665I/rPQgsejJtPUgTZCAp1u6TtpGTF4GXuNJRUknnGY9m2ODJtrHstb59l888EU36XXa3RX+DJdN+x+iVFbRQQgT8io81nAVtQq/KgHytMxVi6JtX6/uYgd3Xti1RwvbTvJoHUu/QppjWVQb4XkNB8dwrxfgIBzmAgrueYbWQgy0fLDo8a0jEfRQwlD/amGVNcYDyZ5hKNiKU/PnoLYHMXvZiQcMh2vAsJnelop60xgKBRLTZQpoVfRccrxz+riXDW6HCt1QTDK+uARKr98VaKSSrhto3FPQu4zn2UhRhKXXp9b4TO1lMYnI/oROK8c1pHDhJCrSNKBDt/US90SDXB7sIyI7qVKQ36uCXMdBxm1vfCTgQYwQO62pa+RGq/TR01ITvM9QL0/VCuTvWC4gSo0SRejl9QEa0PdA2kzTaIp/V3wzHIvdDqhjtQYF6Rav8jlKMscZ0KwJai5b1pH3xs974PzKscSfmsQv8aR0wfe65GYe4TBgJ3wiC64NpmcjYU4y0IkknXemOaqNzukeA/GFQMZLdrlQzCw5Or8zHrBg/jK6XRvI25cC41YaVr2SO3y20lU3X2FwQjpmxQYWUqK08w9pN6oqjkXgV0sZJT69rggozvzlovgDCeFRcTboM5xRqGvO4DFPdhfAm3Y8Jd6DWObwki8m8YdGe154JQGJs5CVc20F94NUINOa0V3AN4sDcpJNrtW2bSBdpGmsyXeFnjbBw87OXw44OiZ8qT2ySUeR8kvT/Jzwftq9+tD3ZYc0w0l6mIe7npzavbjtD/fSBa1dpqWoxICIQxr3/J67YmBLLreUYBTR4C4yhw0ib
 77aDIJuL
 DqevSFlTe5m9RgnbS34fxYsgTWtotIOd4ZAWuQZL5B/JuICc+sBShx6t1F3HoxBfZfia5nQSK3cuXl7+aiz9ewGuLhokrfG1Ib0DuIoMy48kX85/WBXK2C4zXbey1GMucV6Tvr3YzoZh2wpvF77u07TdEbGIi/AWNkaW4F+5OEQ32kN3gMETGuwwY/vQv8cnHkJmvO07bNzbvqBd/hfNpCSvnkIgqMh9KBcWkvmeAGM4JUAKEflU3HnJB36s6mdQxaBvZtATYQ/9YKSuqJ2uZK4uoXgPmPX9pFwlHqHk1rEVyXh1KJQNIXHvU8IFMaDK/6YqsB2kSjNSecvgs6Lr9GHvL2xY2BCa4tJI0daq0NLi3CS8vlglyv8l/d1lQAKrfeOIEA5dD8JpTVFvrWzhBxr19onzYgefwkvqej3ae2krOZkGMXghfMkvB9OWUMWjya7ojKTi/10fBWQ5AhxUNpiTjkB7B964sLVaB9NTkZd5F+ZksPm59CrNmE8G8Rw0nYvSzTBMG5qEge9+6INrtWS8YRoQkgPvg+pmwASnLTnRrWBnpZxjQ6dKq8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Christophe Leroy (CS GROUP)" <chleroy@kernel.org> writes:

> Le 25/02/2026 à 12:04, Ritesh Harjani (IBM) a écrit :
>> Similar to CPU_FTRS_[POSSIBLE|ALWAYS], let's also print
>> MMU_FTRS_[ALWAYS|ALWAYS]. This has some useful data to capture during
>> bootup.
>
> The patch subject is misleading, should be something like:
>
> powerpc: Print MMU_FTRS_POSSIBLE & MMU_FTRS_ALWAYS at startup
>

Sure make sense. I will update that in v2. 

> With that fixed, Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

Thanks a lot Christophe, for reviewing the entire series. 

In v2, I am planning to fix 2 more kernel warnings, identified via
selftests (currently working on them).

-ritesh

