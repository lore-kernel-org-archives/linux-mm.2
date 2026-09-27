Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89B6C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 17:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8096B0088; Sun, 27 Sep 2026 13:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F7F6B008A; Sun, 27 Sep 2026 13:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B55A6B008C; Sun, 27 Sep 2026 13:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 486D66B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 13:34:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C57240A5C
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 17:34:11 +0000 (UTC)
X-FDA: 85260240702.16.6A71807
Received: from mail-oo2-f38.google.com (mail-oo2-f38.google.com [74.125.231.166])
	by imf14.hostedemail.com (Postfix) with ESMTP id 94FA6100003
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 17:34:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=GbfCDKw2;
	spf=pass (imf14.hostedemail.com: domain of luto@amacapital.net designates 74.125.231.166 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790530449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuL0v1f3+J9yyQw0yqK0TvcdFgWSs593LTmvyHRza0g=;
	b=0s84JASt4k1NdawM78bzDQUSI+lw7Jmu1BgYIX6fveDfl2GTU1m4kCWzWK9A/IwD9c9mKO
	YJmSveOal924eXEuJ6NryU3hBh+2L/vddUPrW4NwHKbSU5rEIZFAfPvqqTDqyalQAtpWrI
	Yu+Re4u4tLGq6YAtqHHzoo4GoCpTj+s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790530449;
	b=x9zmI+orEYzEazcQRmrLYcdNsI3MHogApotpUK8BElpr0cn2uUeIOBmhIc5KovHiamYJBz
	J7gSYLsRNJOVtz8/cerRzR2dUlCuhzcvBLuY2ayczd1Q0LTB5lyB1kJTBkopI7oTx3YRqe
	HLgVpX18Y0qD3pqpFcfD+dKQNGKn/co=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=GbfCDKw2;
	spf=pass (imf14.hostedemail.com: domain of luto@amacapital.net designates 74.125.231.166 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
Received: by mail-oo2-f38.google.com with SMTP id 46e09a7af769-81be5042c56so356207a34.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 10:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1790530448; x=1791135248; darn=kvack.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MuL0v1f3+J9yyQw0yqK0TvcdFgWSs593LTmvyHRza0g=;
        b=GbfCDKw2WpWwQm55M85fQSol0p8tfPWZQN6mFgVz3Z0H0bf03XZ6Lm/LQZH0ROnhQ2
         oR8FXyyS3EQCJoqM7CRXBNjr+GMsTUWrdQism4vk3gS/OaYxKBxamcOURlX/PfM7J3XQ
         2fO15lDqZCLxpUHPNajqNyzwMg3fuPScyuYJgx1oS59ee0G/zXN4dhl0nmTdvGA5rOO3
         q2rTbza/8yys0V37dWMj5aGEyHQO6iC/4jcBEwRC3pEWhRbskBpHHaMYq8qkvhV+B3Pf
         1MVer7oeuImAASAzO/B6bk+NRuWq1em4vEW8cN0rFB4JxvVjw+9aIvptG8CBXampiuI8
         zXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790530448; x=1791135248;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MuL0v1f3+J9yyQw0yqK0TvcdFgWSs593LTmvyHRza0g=;
        b=Yneug7gifVJAk2wNX/+Hqa5WGkKA7vQ4AxehSU6QgNv6mLD8R/lbnQrWU81PvtgGA/
         zUTGf+1HHcCl+BpqmVN4S+gGQ99B1jkhrf8661KPZK0SKkXHn0WSrRoh6RRbTsThii72
         ePKHHKp9VmR0ZjQMFZqM06+1DKwkmGoBB4mx2N5Shs8+dL2ApwS8+jQcHdbOxflf8qPL
         nRZT+Voza9f6soQEmC/8afS4DzkhIPp2qLH9bZxhzc05zPyIx2p3rqigUAGyo136CFBe
         tZcS74AHVan7FlU3c/7gy1TeSRQajqGwk6qS+ulRwHN60yKKxNez3XRL1WFJsLKaRzbZ
         Akiw==
X-Forwarded-Encrypted: i=1; AKwUvBwjT1NRlojBa6YfIUzpOT+7NHrM14W8V7H5qEX4jPdfoWS2TcrRXdFOjiNrbHIoRVXAV9kr1tInZQ==@kvack.org
X-Gm-Message-State: AFuF++lV9dZ+raeLn6oIwDLKoYw6y7u9p2qVKKkax//9kg2S3UQeMuOc
	L7tH45HtASusiHhHrGPRGf8/A4IbQhKEssR4vy64dtzPlhW7ubuKhoQkPl1bI8Wg2w==
X-Gm-Gg: AYBFou3TUxuf/1AOUoz3Fs22SMjOPQ4R3Fyzs0t7EQCi478ZCaOvBVT5WqxKWIZRym0
	MX526m6gGhL6N8vciW3TPGIGAF9lj7DTGmYpwM5yVKjjzhPKZDYPWwrzNzpnDNpLc8Z9OOoO6Vr
	tB8lRr0t3sXWAPJzbs5+fXXg/9DvkF19ItciSHL5eK6U3weCYRuoeuP5N6F93/HOwlB7Tw+AWeD
	N4foqFL8CymoUzHGL4HaEx3FETVcpfS7g1qNGmo9WDyyhh+G/Dqe84o7y0qHXMn9o/A1J99uXe/
	KJ/q7FKp6zSgY8ynNr4ndy/iFKFsQpglgTNiTmXJVA53S6NnwZZPzivcZ8wtaVfTuswk+uGjtoz
	Mth3X6DtTSICd2rTavNa2QGOlTj3PfRJvFNtqNmdRXkFtkpbcgHr5vq36+kqIhtuMQdlgi8dFaY
	sySp1YVdzYg/NexKva0m6S+GilTIotyrQUjHer/C6rk9GaAJQWN/OdtclfrP/5OlFaxDgd+kpdv
	kfrhopgYWG4hkVUTtiBtni9Fi/qGQ==
X-Received: by 2002:a05:6820:820:b0:6cd:3ffc:64d2 with SMTP id 006d021491bc7-6d5bac3e146mr7371645eaf.77.1790530448403;
        Sun, 27 Sep 2026 10:34:08 -0700 (PDT)
Received: from smtpclient.apple ([2600:381:5ba1:a8b2:19d5:7f67:de2b:c3a5])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6d883394af1sm2755239eaf.13.2026.09.27.10.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 10:34:06 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
Date: Sun, 27 Sep 2026 10:33:53 -0700
Message-Id: <3FDF3191-94A5-42B3-A33E-12021344D7BD@amacapital.net>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Yosry Ahmed <yosry@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-api@vger.kernel.org, Alejandro Colomar <alx@kernel.org>,
 linux-man@vger.kernel.org, Karel Zak <kzak@redhat.com>,
 util-linux@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Vivi Rodrigo <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, Rafael J Wysocki <rafael@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, linux-pm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org,
 Matthias Goergens <matthias.goergens@gmail.com>
In-Reply-To: <20260926045517.3458413-1-matthias.goergens@gmail.com>
To: Matthias Goergens <matthias.goergens@gmail.com>
X-Mailer: iPhone Mail (23G90)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 94FA6100003
X-Stat-Signature: yf3g6xhwk9tk1c56zajsd6d53h61tcfy
X-Rspam-User: 
X-HE-Tag: 1790530449-111740
X-HE-Meta: U2FsdGVkX1/P8XQhJdTyXzaJkBsC3BV5ju0hP5/S7y6IUsDOGblcvCtBgx+rly/Wj+/53nFChNyxlYy1GWB115SzmNzxidaeiW5kp9FAVVckCZE/LnIRNrlxsEG+/AAlsJP0Kv3nGsaIsx9UfI80vNgA5fFqSFzy8QYXW5JGinuWhfQsAELdsNyluhhuiAkvVL1EwIc0FsO4DE9zj6y2iTU8suPSp9YP78T1jRij1j9FBYDmtnKn84Atrwdjoky8pjTEZbzAn3yqCmTrbduTWZ/pEJ3nhk9tnzSkGjlKHNqKeZgGcVrltz59mRGCvIdxO1RvrhamrZ5kI9PILFnaWRovPRcEzJxC579zB1IZ953lxDo42c1KOSkYPsQacmbHngCif7a8mS2bVNH1dk4bV2v3wjo5PsYvGypnCR50p0d9JWI1xzoXZoyrBQflngTqDTe57/bgwW+/BgXxlhq7ehzQWfXJ6TbL2MisXDyipFeFI+0/srS06mwViJZu2znjdPKOHOHR4oa54oi2Rxu2oZfNo5Pwk8uHTbpQkrhbKVD1/o/aJGSaZYL7ZXoFnWO3y1RFGlj35uM/o+M9zoLWdRxg26mM47sHuYGmLm7RdEUKJc+QKjVsKxjuRtqRRlzyBxFnhOtKSxsFS3bnDo9sPIrNZ4IotYjQ0uu3PuNh7s28gfxlOVOtQVn00/vkKRU+8Mm1qsnES6M/4u4VYbfL9xJ6plkc8yeyO7npS4dzgd8K0Qm+PUNU6To+MwKopfKhhAewuzsx68DLkM3DLssfyqxvbweMNaZOhBAiwL07DTxdb2TwWquaMUzPN1zPUimJ7BRQX5inc0BGpFrZfZjU7aRwR/twC7m7AKtV9tg3+QV2MNxEWt2ddttgQPVQ9Av/Qu18B7m0aLbbWjxUuWSBGVozJYnlhQWkrpRqsGdCzyqyXUQlBsnXFMGqmmFjw7F5mT/9KhkjOC23FVZ9pS5
 DvuQphIu
 V+ywFWtxW/Pm9VodtCV7f8kLoXUl+8crZ72USGz6QhupF+xeb1+3u6sHHEwWYgCHIvkwG9RtYu0pQuR5bHSjYNZRWfvurDRe1l6ddfzzqYWGRJ/82PQgoAnVmNPUc4nuklzPhGbJHMT0RuyehehO2XJ8g7fZDwmlxEmhevkAmzGzCIeRnvrTsYVu8hCNZdDa84qg3laoImB8VON/sU5MwA5k0sOnFeNHVH5c6XFEHDLxwpGb+TBk++IlZ4hkmukDfCLP+I5WthMs/K+y9A48venWCS5qcR05klsDr8SbyntIpdw4zG8llNOCl5q6gEhxJJRtzliXAXmGNXo+sZZqgIHWM9LziHHBJmaOhJXQ+98FMU6Or/IwVi6H2wSRs8E7ojz662OzCAW/bo6emF5kunkjhbRds2M/1EQ1RVuk0bnmSzDQkWS96DUO37e/fP/q13WND3oEL1zUx6IsGmi6Obn+rTR5TrbWaRQGVZL5fcQhEMRbcH0zDjNbnqb0wpb9CTtKT/W4R1uFJlbxaxj71psX/l0Dau7Z4VBYdZgpH60ndCM0vZ21ZNEZ2k0UtBj5/TvCz0jSrN+DNLE9QlzKVdSasEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 25, 2026, at 9:55=E2=80=AFPM, Matthias Goergens <matthias.goergens@=
gmail.com> wrote:
>=20
> =EF=BB=BFThis RFC adds offload-only swap areas for deliberate cold-page of=
fload to
> backends unsuitable for pressure reclaim. ZFS zvol swap has documented
> deadlocks under memory pressure [3]; compressed swap is another target
> because writes may need memory despite free logical slots.

This seems unnecessarily annoying to configure. It seems to me that you=E2=80=
=99re creating a bizarrely named administrative flag that means, roughly, =E2=
=80=9Cswapping to this location may allocate memory=E2=80=9D.  Why can=E2=80=
=99t the kernel figure this out itself?


For that matter, how well does this even work in practice?  If I configure t=
wo swap devices, one =E2=80=9Coffload-only=E2=80=9D and one conventional, it=
 seems like the relative fullness of the devices will be mostly an accident o=
f what triggers swap as the system is running. If the conventional swap fill=
s up, is there a means to proactively empty it?  Under OOM conditions, will a=
nything preferentially kill tasks that reference memory in conventional swap=
?

Is the locking and recursion structure of the mm code such that we won=E2=80=
=99t have deadlocks where cgroup triggers swap to an =E2=80=9Coffload-only=E2=
=80=9D device, which allocates, which causes memory pressure, which then tri=
es to swap more to conventional swap?  (Maybe this works fine.)

For that matter, if the system is under overall memory pressure, why do you c=
are what triggered the particular swap operation that is being processed?



The remainder of the writeup is IMO somewhat incoherent.  To the extent that=
 AI was used, can you read it and make sure it makes sense?

And the first few hundred lines of patch I skimmed seem like incomprehensibl=
e churn.  Adding =E2=80=9Celigible=E2=80=9D to a bunch of calls does nothing=
 to explain what=E2=80=99s going on.


