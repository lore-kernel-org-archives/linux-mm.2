Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E709E88D66
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 10:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20DAE6B0005; Sat,  4 Apr 2026 06:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5836B0089; Sat,  4 Apr 2026 06:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FB496B008A; Sat,  4 Apr 2026 06:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 020C86B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 06:02:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D5DF14031D
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:02:21 +0000 (UTC)
X-FDA: 84620433282.29.90BD474
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 00BA21C0004
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:02:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f+7nfSJi;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775296940; a=rsa-sha256;
	cv=none;
	b=7g7XjHY9RprQ4cXaIlUMwZor38/irlVdI3OxIQww7lOGTP0jIGRGV7GaorU7MaIKRPghtQ
	64SLvRkJBJUSQD4BHiUUb5Ff6i+EEdTtIs3tIU3+Qbf3/+A5sLlyZoO2hCoRu1aCutOoSG
	DRfZ5pQkzCuUkCnXEjotyhrCQf5BscI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775296940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bj8GY8uxMfSQCrxRw3zkFeoAncweoq0o/+nHlRO48Fw=;
	b=mtOcCYe2CORugE+5mytCgfyaUF+o6fdliGS3tHD5/WB2hQ45vpoOtLgV6L3pZV7XM96dNH
	6vwN308Pp1UegnoL6UrnQ+h5T1zBUX9HHgrh21qI/D9baJLKzpg1M+CYZK8Gwp3yeW90UK
	QKCmvGgYAOl8ft+owjgCJwTwyQZNw6w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f+7nfSJi;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B92C842D54;
	Sat,  4 Apr 2026 10:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAC9C19421;
	Sat,  4 Apr 2026 10:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775296938;
	bh=snSMIj4ZyzLySoCeSAr8jE8/ngtAvFRBuQqkvK8jZT0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=f+7nfSJi+F9GCY34zDpGrAXBlx5ZoRW+/sKBWW2fcdNzLklZtfPnBiRiA0Y+YUjpF
	 DdR9n9zgO9qZuTvxpF83au36YdgsacIIfza8a2l4sQci9PHxsPBY0dvphdTNPxeClC
	 OvjInO4t1Cg+OoE6RisEbYEX3V3YihzJRY13aZazHQHsK2m0N73Y6CWV5FKfZssaCa
	 mUmVr0YegANZ7YetPvvjgBfJiuHA2sV5hW5jIPMTbezDMuWDFetYop77L65A17BC7F
	 LC/xEixA9tersbmA8KbPwGp6cAkT/5mIc+/pk+q6AS/DXXYYFbKC0/YTVlIy+mmdlD
	 SSXqNQwGnvbGg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Shuah Khan
 <shuah@kernel.org>,  Usama Arif <usama.arif@linux.dev>,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH v2 0/6] selftests/liveupdate: add memfd tests
In-Reply-To: <20260403150801.f42e27896fd2da5db6ca3425@linux-foundation.org>
	(Andrew Morton's message of "Fri, 3 Apr 2026 15:08:01 -0700")
References: <20260403194014.3704180-1-pratyush@kernel.org>
	<20260403150801.f42e27896fd2da5db6ca3425@linux-foundation.org>
Date: Sat, 04 Apr 2026 10:02:14 +0000
Message-ID: <2vxzldf3avrt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 00BA21C0004
X-Stat-Signature: fqcw66mpjbqznftppokopfocr17gk4j4
X-HE-Tag: 1775296939-237400
X-HE-Meta: U2FsdGVkX18jo4u1EG144xfFLS4WOaRHhICnx/hFshYX5qfqGZYGLJpqKkgxJyjuVU6OqmpFPdiOPnPwt9QqGSCcSlqXK6BXeUF59LpCxWV+TdQFGaebmzQtNZtU0eH1rJm8KuAaZ97sYOvfLjORid3jg6P/uwJL+PD/DXzJfDRCpwbksm+9JK0rjFOqkMAIP7fvO8h0YGHF4fWsqjrWti5Lb5+ypO8y+EAG71tAoQQdpeXBC5QeILShuGBbblfZY2bPVnkmdD21qiIzqvkrApX/VJqkUOJcBpYvnu47nlfZqrVJEseZ63fkZbv4jAysDIsVPbdXt7YpeJ6v3FElKXyZYWMseXDEBCeqqA1pVwozvoseI8G/VRwrejVBreosjU+2ZmswYka8jOmdF/DmYP1rRSdT4pAgBVW9E3+e/Zd6L0jIYtjTLW4DYXlqo6MGdmG9cQt+KVEP1HFdsMcAFyii3QNto0p1BZURowcyhjwov/hvdZ1OwD0y+FcA0YNXyE1JUDTR0HQOcDwoX60NWFCmAsBzVLY1cSkwsIb3gVDFSI2Ocu6/m2zEISljqA1mZgX6GnQCzK/OZk2PhF/PwwR46CErtkIA7qeMqMliZldxpxJsT/x6UGoyg68Mxeda3Xa57jHpAzVcaL/PtTCrbUihQSMazwBXri5MJr2Ba/9q9bBdMgPJy/JiB2Lk3nKGXYNAc0PgywRw2jrU/7wFRYkGEHjGpJDeVvmNjcuicdk+czxsCst3IWkA3ppditZvXqfeyMEsLd9N/Gj2FaEAkeRdyygknbQx9PAJzPqlIM54/KFoqGYsG28S/i4FSHx83R+/T8iqMs8xn0xGZ1aN6faXlLao9U3gmhCvs9TtP9WSDaa5Oe56tNoiIy5KACNoYgtVGpN13cbUOxHzjZS798rFfH6tnpFCqYCR7LadJ26klc2Srpy1RW2juCpoGhGIY3WIF1LdYH8lQQyRMmU
 sAt/Wg5b
 OhPSY+kOv6st0JQDdioY7MHz7Ikg/oMxXFweuI4+vXcm6mydofoxCkZo1mES7wkgQXqA3cRNW7qH4ipG9olDssSwN9/fIp7O4t9e/DKqn4InfreAANZhwzaPZOP94W21omvzAzMh5s/ebdWL2py70hEL8eAQoWQJi7ovkrEJ7spfhJNUJo39uFjXBAh5UEo7Vntutf+18hP8CjGsQKd8ctUS187V0q5TU6mtP784AD6fO+nmMzqaKxPWiTZ9lWSRj7FRi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03 2026, Andrew Morton wrote:

> On Fri,  3 Apr 2026 19:40:06 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:
>
>> This series adds some tests for memfd preservation across a live update.
>> Currently memfd is only tested indirectly via luo_kexec_simple or
>> luo_multi_session. Add a dedicated test suite for it.
>> 
>> Patches 1 and 2 are preparatory, adding base framework and helpers, and
>> the other patches each add a test. Some of the code is taken from the
>> libluo patches [0] I sent a while ago.
>
> Look like a nice series and it comes well-reviewed.  Maybe my "we're
> all full" policy-making should have a selftests escape clause...
>
> I see that the malignant gaze of Sauron's eye fell upon your work:
> 	https://sashiko.dev/#/patchset/20260403194014.3704180-1-pratyush@kernel.org

Nothing escapes His Eye...

It does raise some good points for patch 2. I'll send a v3 shortly. It
would be great if this series can go in with this merge window. Since
these are only minor bugfixes and no fundamental changes, I'll keep the
R-by.

-- 
Regards,
Pratyush Yadav

