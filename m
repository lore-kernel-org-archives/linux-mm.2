Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D351606A5D5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 15:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=colorfullife-com.20251104.gappssmtp.com header.i=@colorfullife-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=rxc1RZ4z
Received: by kanga.kvack.org (Postfix)
	id 304C36B0B8C; Fri, 23 Oct 2026 11:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5326B0B8E; Fri, 23 Oct 2026 11:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4246B0B8F; Fri, 23 Oct 2026 11:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E39A76B0B8C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:12:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BED31A012E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:12:19 +0000 (UTC)
X-FDA: 85354231998.21.349F2E2
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7E91340007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:12:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=colorfullife-com.20251104.gappssmtp.com header.s=20251104 header.b=rxc1RZ4z;
	spf=pass (imf07.hostedemail.com: domain of manfred@colorfullife.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=manfred@colorfullife.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792768337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nChdOq/b/gyYFhyjIipIGWStlUHbMLmpH6JMhnlOpM=;
	b=a+Qx2XsuKHgCzb7p1LXjCTxHKaCsAg0CEF2gQ7hOAbz6Xp7Y0ak3tuNnsIlUgAktgG6iHv
	jYpIUJ7uihPAZgroWHb/Tlm1fxC2tiM6LVHzsY+bHawo7TvNZk8QOTGBZCS2t0YTBT/ZSc
	ZVB2vShPd06ysZTa2thynD0ZWDbZaHU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792768337;
	b=fRU0rvyE9moHlztRnotcQ3ptN+FJ9RCMfphG6V7kkBsezS9BvvYd+lnqOMuoQHcmS8/Pow
	lB5ao60kWHm/+0nenDE1litcZZmCe1js5bgnb/Kflv8HEVQ44iNAYZvKV8n/VPuWBbRpms
	uxuU+VHvvUSN6gWDgqYPtNMh4P2/9L4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=colorfullife-com.20251104.gappssmtp.com header.s=20251104 header.b=rxc1RZ4z;
	spf=pass (imf07.hostedemail.com: domain of manfred@colorfullife.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=manfred@colorfullife.com;
	dmarc=none
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48b060ec084so668078f8f.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20251104.gappssmtp.com; s=20251104; t=1792768336; x=1793373136; darn=kvack.org;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/nChdOq/b/gyYFhyjIipIGWStlUHbMLmpH6JMhnlOpM=;
        b=rxc1RZ4z0C34uNuydkCXnnLJxVxYyHUuFqt313WuZbXGF+0+MH5Qd0HZuxyhJ8zhnd
         0BsX5V5Gt4lwmp6qMTbWAZxvFCc90BuEHALiNYfNVLNH+wGwBYzytsLfDF4wgTD3ip0z
         pgYSyA6vCKl3aHKTaNmmjKlGi6pmqIqroI/hRgcNbUhbIvhyCx4wp74dW1IEzr/pAzN6
         MqtKiZL6bzzDj+TSYsJMCn5zrP3+c6XyyYZV64DsMgVw5h9h4ed8cY3L98THwBu2/8oV
         I5ktzo88RxIB1cK26uQCibbaARZVU9JhMf0eIgdXcCWEoWJcboUSPjNqJlciW9s5z/FH
         xZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792768336; x=1793373136;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/nChdOq/b/gyYFhyjIipIGWStlUHbMLmpH6JMhnlOpM=;
        b=cijUWALPabrMOmhZ9YECEFW0w5ikGfMcDAKQ4+23UKJaXoswTKuvZqALVVB9GfYY3z
         dWUVK5bV3e0wPOb3+qFc2ySwRk5llo1QHF8MksGOONkwpCR0kMBEg+bvia0WKqSxQpXM
         DdMQ4LoR8kV54UTbE4qDCBdLXFNv3EdghCP3Lm9ctct6yc5DksilUoLEberDcQ7G60ZI
         yW82FkVl4cw3VnpmDwpK2Z5xU1cs8ZoXu0p4U86OOgjMOguaCvAyEN8shZpBfwm2+aFI
         XZUfJddrCDuyhJHRhGkM33EXVmngbUrU2znGOZmctuzNjz0hlAQ+9RN64K4r03JssUSE
         yLmw==
X-Forwarded-Encrypted: i=1; AKwUvBz8D4yGzyidbxVQhuNI0bt8uEHVZBh/hH2x2QBUzLGVN+wUku1J0xrX+feSVYmU/f8RGfL6lFjsnA==@kvack.org
X-Gm-Message-State: AFq9FYInlQEjRQC81f1h8rGCSptmJZr6JwUgZYxdDuiqvH+lUEu5s49E
	Dp+H39frdSNvoOyRW04UTRJLkpAR6czvcWKQct6eGd7WFi4ZKZ5CbMZa+b631uTujg==
X-Gm-Gg: AYBFou3dreHH72wKh+C75Cw3731vjWr2GfA6qaslXHE+RGgjMi8RJl8LR1zEW2u45RY
	UFrJOqODOtZZzFjYNI+9IZyYDTqQl89JtXpUQE7eajcIJ/EnWQnTCelsGlrzYnWIfckVPCxusIA
	zDLFG9UHN2dorQVnVtIfIVFFOlHSkjX65iD7Vqf2QPn+pZYgni1nqW0YbAXbCJKXBK2dZMY0VVN
	HBDNzF7SehAIGEqGLdClOW+lD7l0ovXDhv6ngY0L+yFfV+qPyX1unBd2JKxZfB+LSMjocRbhbot
	kLRjN/PF9xuCO4PDQtCOu+sKUBpKe2NBIZTc8jz45DvjDdlvklzLYbo7tYoKgJRUlVfSe0H/Ddk
	BBIB/gFXCLkN5mWh3rupE+imn+cZ7LMBFb141CUEwJlZZq8jucc6WY8eLHD5vpMoeYNYV3T3eBr
	pvXcyGZHLETRwby9EvlgxJJjU5t/e8QZHkqqrYRTGqbVGbmuZvEliteZG+WF8GkUPgHUvwTAlcW
	d2nOe4QUZ+cqMVcqqLIr2RxkSjIx6cgBG2lq3P0bZOASZ037a6ZPKb9nmcvB4B+GGgeT9Js79mj
	os7367JttWp58kpADrpbNJ/jCnXOgUlDfAsXLSDipPFH8BQFqr8X/kI4DN//4RfTNgU/8zdYDCu
	SThiuPr/hPrqT7BA=
X-Received: by 2002:adf:f308:0:b0:48d:b650:69aa with SMTP id ffacd0b85a97d-48e387ea74emr3047183f8f.50.1792768335827;
        Fri, 23 Oct 2026 08:12:15 -0700 (PDT)
Received: from ?IPV6:2003:d9:9707:8b00:3fa:3a3e:198d:ab69? (p200300d997078b0003fa3a3e198dab69.dip0.t-ipconnect.de. [2003:d9:9707:8b00:3fa:3a3e:198d:ab69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3d40e830sm347543f8f.35.2026.10.23.08.12.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 08:12:14 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------lWpYfqxAIT1R3O0UqvedLtQH"
Message-ID: <24afe3f2-8cf3-4182-a5ba-951e3b574f12@colorfullife.com>
Date: Fri, 23 Oct 2026 17:12:11 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ipc/sem: reject negative SEMOPM values
To: Yingjie Wang <x-professor@outlook.com>,
 Andrew Morton <akpm@linux-foundation.org>, Alexey Gladkov
 <legion@kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Vasily Averin <vasily.averin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Michal Hocko <mhocko@suse.com>, Alejandro Colomar <alx@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <cover.1792724953.git.x-professor@outlook.com>
 <4fc7f5cb6bea186c5266415fcadb7e26c7738a85.1792724953.git.x-professor@outlook.com>
Content-Language: en-US
From: Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <4fc7f5cb6bea186c5266415fcadb7e26c7738a85.1792724953.git.x-professor@outlook.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E91340007
X-Stat-Signature: k6n479fghum3887btest8dod3i6tudex
X-Rspam-User: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792768337-931054
X-HE-Meta: U2FsdGVkX1+B8lxFIL+jkTRTr6RVqEQvfCshXxSkvk073CdINg4KCrJpiXcdQpz8KZLhlmqas9HHIezeQK4yuH0szdaXzNf3Y0h7um2a4mt0X5R0/fg7WmcRkiHBhcboJ0yRLXDw03XSx8NPPM/EIPS2c9oQc88IgNcKGfmmiK3gW3mRGWrAetfCdrChf1gMxb+PeZdqJnRXWVBIfmpBt2rzCrO1phTwZqSEfW6NBw9E6Z+dWO1trwukumJgEEp9hp/Je6wafghj3Q8o0VqtUCjPZ6bdCZpE7Zm+pEBWWkEc72vBkbxw8albgqycU1K6HNYRBFD8GB4HUx+Hm4gDztXo0N3fO/yZ2ZO+xrdPuBr9vm8VrWLk70JWU56qVRWk111rfDQ4+qmBJPbE9dOXxM4wpA+bkk4m2zYXC+F6zMcUEwGCJHDm+tbQUev/IGZQk3WbFpDwstmtNIwJ2YHq0lrPkIqBc2/NAK6PtQMZQTFMNJ66Js8AlWqK3y+DZm1OaReJ4pyPzoBR12Im4nzCFhJoqbRQnX4UYnV7JHuPvRXiMbWpllu8KWNueyRhdffkJZMq/QRtK11MGKBZWNSDr8GEV3f1bNUsOJU5630XcKXpKnrqVtEpn3k7GYHRZt+axzTxQPKUunRyT6wHgOfUJsrtZSYRZtkTgoTShJ0dNjEQZCSNdRK00g7MJMKxwXvjXnQVOfavWo0TSykBBjItjibhozUIsD7XjniVWVxdEk3E7Lmlu0m8bfiYx5jjFPj5qaBMDdE6g1BqsInNQ2yXDmjkgVA1pdPEb7Gjs08u4MtxDlQKz3hbCNsHFlc3bwe/PuGq3r3qO3YUydUiIx8GMhiD/K7vrQIZn7rgobN6qb+L8C8e2p8OX2Qhda7ai1ye9iSgxjzY12futva6PSbCYeTuUbKxZ6aIWN06HiR3kQdCzQu0mSGGSib0kTp1uDo6I0L+uuAg2HNJmQ2UgUl
 cLxXQZoY
 +kCF1Mc4j90trtNAZGIKcTtJY0N0eTqmZbs5q0MSRneKPmx8FfIfM0hPou31NMMUaeAjJY1Cy58GqJkb5cSBzEasCDP1sgod2pJO39gt0l0wIWHe3U/m/jw7VPwq+sck9zQCYPtyI1m7kf2/oUfac2KzI2B6TUEoICSvOxBm46CiyZSWNBygQpj2mSPCCWZs3IK+OTFNt/4LbeV0MTPQwbRX323nc88Qb9cxPIsxq6SCPLfvEXujcZ/zmWTHU+06jyfD8k7Qd1PXa0/QDbk2MJ9oU7YuvqSB2GAnUfwlw4e9QpQyuZMf31DNoYrRKMfA9vajl6HUeq7uzKpcTKY13P3rgknkWTOhfpSA8xc+ifEP/0Nb8P7yMbELiG5WVPdSQnZsvmo9HsH/qLGdaS8ftkKNDgxeTKxs+ecZn8aOBVdnzSKXQb0hO3FlHbFjj0HtvMU9JGAOLtRG8MLJEllPLHY4cxgr5q2tChVMRr/OlALhld3AHNf8UftpVcM2Ko/JKnq6394OPvNj1/UliofOWaGhp5lxfk0lQ777E4JHB5PgOKirIrYMvMBKUVbpbiSNsdrtKqRE2uewN/d/rU6s/wtV878DHer5aA+AxM4sRncxPYFk5uTZDsO67pM5XyqSlED2OXtWt55hWLoSXV9XOFhMOckINBRDAvyl1sykLaYbKT1Du657gNXNbUj8vPV+zj1Hm//7H9nbaB0r9Zo+QbM+fbKcOYtg0hFaXo+WDktid6E3OLfcOX4Wg9Kn17VYEf6TgGapWfll+nlIdSD/s9zM4Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is a multi-part message in MIME format.
--------------lWpYfqxAIT1R3O0UqvedLtQH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yingjie,

On 10/23/26 5:19 AM, Yingjie Wang wrote:
>   
> diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
> index d038d944257f6..2a542f838a530 100644
> --- a/ipc/ipc_sysctl.c
> +++ b/ipc/ipc_sysctl.c
[...]
> +
> +	if (sem_ctls[2] < 0) {
> +		ret = -ERANGE;
> +		goto out_unlock;
> +	}
> +
> +	ret = sem_check_semmni(sem_ctls[3]);
> +	if (ret)
> +		goto out_unlock;
> +

The mixture of an inline sem_check_semmni() function and inline logic 
for semopm looks strange.

I would remove sem_check_semmni().


Reviewed-By: Manfred Spraul <manfred@colorfullife.com>


--------------lWpYfqxAIT1R3O0UqvedLtQH
Content-Type: text/plain; charset=UTF-8; name="all-inline.txt"
Content-Disposition: attachment; filename="all-inline.txt"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2lwYy9pcGNfc3lzY3RsLmMgYi9pcGMvaXBjX3N5c2N0bC5jCmluZGV4
IDJhNTQyZjgzOGE1My4uNmJmYzY4ZjA0MzUzIDEwMDY0NAotLS0gYS9pcGMvaXBjX3N5c2N0
bC5jCisrKyBiL2lwYy9pcGNfc3lzY3RsLmMKQEAgLTcyLDE1ICs3MiwxNyBAQCBzdGF0aWMg
aW50IHByb2NfaXBjX3NlbV9kb2ludHZlYyhjb25zdCBzdHJ1Y3QgY3RsX3RhYmxlICp0YWJs
ZSwgaW50IHdyaXRlLAogCWlmIChyZXQpCiAJCWdvdG8gb3V0X3VubG9jazsKIAotCWlmIChz
ZW1fY3Rsc1syXSA8IDApIHsKLQkJcmV0ID0gLUVSQU5HRTsKKwlyZXQgPSAtRVJBTkdFOwor
CS8vIENoZWNrIHNlbW9wbSByYW5nZSBbMCwgSU5UX01BWF0KKwlpZiAoc2VtX2N0bHNbMl0g
PCAwKQogCQlnb3RvIG91dF91bmxvY2s7Ci0JfQogCi0JcmV0ID0gc2VtX2NoZWNrX3NlbW1u
aShzZW1fY3Rsc1szXSk7Ci0JaWYgKHJldCkKKwkvLyBDaGVjayBzZW1tbmkgcmFuZ2UgWzAs
IGlwY19tbmldCisJaWYgKHNlbV9jdGxzWzNdIDwgMCB8fCBzZW1fY3Rsc1szXSA+IGlwY19t
bmkpCiAJCWdvdG8gb3V0X3VubG9jazsKIAorCS8vIFRoZSB2YWx1ZXMgYXJlIHZhbGlkLiBB
cHBseSB0aGUgY2hhbmdlcy4KKwlyZXQ9MDsKIAlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0la
RShzZW1fY3Rscyk7IGkrKykKIAkJV1JJVEVfT05DRShucy0+c2VtX2N0bHNbaV0sIHNlbV9j
dGxzW2ldKTsKIApkaWZmIC0tZ2l0IGEvaXBjL3V0aWwuaCBiL2lwYy91dGlsLmgKaW5kZXgg
YjE0OGI1ZTE1ZmM2Li41MWI0ZWZhM2Q2ZGIgMTAwNjQ0Ci0tLSBhL2lwYy91dGlsLmgKKysr
IGIvaXBjL3V0aWwuaApAQCAtMjQ1LDE0ICsyNDUsNiBAQCBpbnQgaXBjZ2V0KHN0cnVjdCBp
cGNfbmFtZXNwYWNlICpucywgc3RydWN0IGlwY19pZHMgKmlkcywKIHZvaWQgZnJlZV9pcGNz
KHN0cnVjdCBpcGNfbmFtZXNwYWNlICpucywgc3RydWN0IGlwY19pZHMgKmlkcywKIAkJdm9p
ZCAoKmZyZWUpKHN0cnVjdCBpcGNfbmFtZXNwYWNlICosIHN0cnVjdCBrZXJuX2lwY19wZXJt
ICopKTsKIAotc3RhdGljIGlubGluZSBpbnQgc2VtX2NoZWNrX3NlbW1uaShpbnQgc2VtbW5p
KQotewotCS8qCi0JICogQ2hlY2sgc2VtbW5pIHJhbmdlIFswLCBpcGNfbW5pXQotCSAqLwot
CXJldHVybiBzZW1tbmkgPCAwIHx8IHNlbW1uaSA+IGlwY19tbmkgPyAtRVJBTkdFIDogMDsK
LX0KLQogI2lmZGVmIENPTkZJR19DT01QQVQKICNpbmNsdWRlIDxsaW51eC9jb21wYXQuaD4K
IHN0cnVjdCBjb21wYXRfaXBjX3Blcm0gewo=

--------------lWpYfqxAIT1R3O0UqvedLtQH--

