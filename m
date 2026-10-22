Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89991606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=BY3azg0C
Received: by kanga.kvack.org (Postfix)
	id 707AC6B0836; Wed, 21 Oct 2026 22:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696506B0838; Wed, 21 Oct 2026 22:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57EB46B0839; Wed, 21 Oct 2026 22:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2ECC26B0836
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:07:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7CFE12070E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:07:01 +0000 (UTC)
X-FDA: 85348624242.10.D8C89D6
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id BC529140002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:06:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=BY3azg0C;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQ915uMcXwm+HIjz60hdmKSaQ15t6ZjQjfLrkfmZVJQ=;
	b=xelf/onXOJuDimJcx/yQg1wtotmjmyHRSWmgQSeQLaZz8IStGLSMCGJpV/YUmPyiHhzqek
	uuc8UXuqOYmxrhoe7CLLhfKiuuzh/kVoTwab+LSDHMbgCtkwezPKK9Sxdgy/X5eheqEs2Y
	93hm9yiubKkFzVIXXs9wsxVnQqFU6N0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634819;
	b=zJsW0M40dOpCNrEgbSmEVcb4MsHmikNmQ6X5vBRrtH2DsNmgmQ2AemMgdp1/DsG1+sLF03
	gVeRNcLUdO7i5Il9mmig2cPvPfioV8Jij/M5Md3TWXTThJyMLwvxBzzKTtcvZ8o4rThV03
	Q04s82v8JdauHVJALPQyvKGKM1m1JMc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=BY3azg0C;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-3514b90bb89so3715714eec.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792634818; x=1793239618; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eQ915uMcXwm+HIjz60hdmKSaQ15t6ZjQjfLrkfmZVJQ=;
        b=BY3azg0C6ytJOitzbvSu3hPkNvKgW/Cz2L3U2Y8uV6q5tyO8L8IqjBX3tzP14nnm+Q
         oXV3WwQ5aRarq0m1yi8RwvppSN2QXOo7FdOC/mSLnLCUTYPxbLP2LIyAxXPpv8UkF0uw
         0RzBBjlY9O0ew8705aF/irnNXKiGNoY8vMWOQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634818; x=1793239618;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eQ915uMcXwm+HIjz60hdmKSaQ15t6ZjQjfLrkfmZVJQ=;
        b=gvRQfhU59A7DMDjUKAwah75R1qI+f/C7hbOw/37UHvOvBKQpy/1Se+wsP1wJUbMJxt
         6gYP6uWYxxwz1axRQd+Tt8Uf1robPVsHGhP0CTJ0Xt42ylJIne0epZoXA144o9LluURt
         9HytpDJLkeD7Xb4KMTqMCkO64hq6k057dftjOosbMXQk+gsQBWO9T5gzhRH57XJluUd0
         20rhtdUSykXnhB1+Fm/HW2TJaI0ofBsKWETwWw/ERNkARkLr/SNUuTXZcw0TcBDSTgcx
         dzYd58NF9LdevKbab+TH+DQT1h3YkvFiH/tREEfwI8jqjg04UF81F3pqzDjkIv/S9je4
         09EA==
X-Forwarded-Encrypted: i=1; AKwUvBwCshA1P5vdktFZDzS/D7SnIzLqgvKOsehFW/AzjyZRrBtVm3y1DQ5J6G5maO6kznSTQkOf2mk+eQ==@kvack.org
X-Gm-Message-State: AFq9FYKbwYtvkEFgX2k9xGkY0VcJADjRzuiw7sIth+dDsg0nb7j4CbC8
	1indmhHP+t+kzl6rkCDMjKylOjE4htA/M5QbAAZj43dAgWxpvobxe26jstWIIfSyYQ==
X-Gm-Gg: AYBFou0F8l6rnmdEGImSYn1Dva9uefQU2hqMVIbbzm7XOOtzwaSavoyxbopPPLil1Vf
	LcgGXScBiHn6cmU9ITfwBEVXXA0VauVQIdnBnJ231UxumZKqe0hpIsUW4AIGwB2ynS1YQnBH08m
	NlCfZ9jQhPMHqVj4gVP28zB5u5TcYIs9a2v4VFoiiTd34gXe5XtXRFO8yOuVlRYclDrAJXJ4/yF
	JbVEnQ3/pjxCAU0Q9/7thMur99nHcxwUeXIHMYky5ROSqKls4g7yXSicPkDVKsjyOJbHtgwdt+p
	s9lPnY7XwFapTJQ1a0yaIo+q7v1VIpV5U1ltbl2OV4gzGt3ow2Qq3Je0G46h0Ss9bCmmuJVuywr
	MIaA5V1ISQhBqa7wmL0haSKaFv2HLZdYYWT4mOfJ3rfBTjB0O/dpMd/V9xTzaIIe5B0IrpY4tVh
	GDnVxqFShk9+43pePS34Ql9BSrPdYf3p/w9puSiMznNhbOQ+9ETgYb7HYRiqN6yrX3h8ZTVDNKw
	GlSjANY25tWP1s5vGUc4TDSDjaPHNLQ0bnDzg++6lZRgrP1XED2/0cUJnaJDsLDwaPdr28ubQak
	0LdJsi+g0qBHfAU8tLlb
X-Received: by 2002:a05:701b:4308:b0:14f:fb87:cf62 with SMTP id a92af1059eb24-190a5d6f6famr4655442c88.27.1792634818203;
        Wed, 21 Oct 2026 19:06:58 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:5145:5add:2df6:4671])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903d3ae06fsm10318111c88.19.2026.10.21.19.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:06:57 -0700 (PDT)
Date: Thu, 22 Oct 2026 11:06:53 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hillf Danton <hdanton@sina.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Message-ID: <atlt8YGuSxgRb5uE@google.com>
References: <20261021075322.923-1-hdanton@sina.com>
 <20261022000822.938-1-hdanton@sina.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022000822.938-1-hdanton@sina.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC529140002
X-Stat-Signature: 5rddxsszcmh6ges957bbj4my6d5mqwnb
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792634819-230015
X-HE-Meta: U2FsdGVkX1/wWr0OVLvYBTvcLARP/dVMTyNWhMjezOqLlTMJgBHKduYuI24tgRVLvTaQd/YYp45ZnlI4htack5CrQjJ3x7zoHIFbF7oQ9mtLbuHTNwuxqkeE3NuSEnMkoP74/gMBAuntUZJ5ZqLfDa32XDVvHlnubVNBJYVYROeOPJfu40rYj7Q3x51Hl2y7q78/x2xFNx0mlDyteNjksWQD74ibHHLKFbux4M2OMr525V4J9VToqXXBgbLJZj7+oJJiYmXPoSD6dT/75rZs+OvdgrDAC8dthfw7F+NFPINApwVWBtBvDZSWHkmObuMOqXOKYLoHUDALM9hkqqdVlo9JH7umIQV+aT4BaEu0n2hheHFwlzxB5xDl9WRVwv9Dy/oqFhz9Sf7UdIfFZ69lNqpGWOqrL2Zmj6ZQV66bnJ2k888BXjnYbzQ+0fjejt6M7mUj/pDC+4aroHhRNunozodHqMrriOrf8Dlha6Xizn16srSlW6WTTa+OGcYZxMo/Zz8UyX4XggqblklM80ZDDR4b8GDBSO4iNLnll/UXxB48Lg0aE+h7ekH9N/3fZ3VFr8w9eW9kqAX1TvIiBALip80GIEnD9TjI07NMptV6xeKsokr51Qw/A5bTuxjrfwgrZl1w/g/iJa45ofszopf/lW4fvqb8ZiycOVRdYClKcpqqPCFtoUlG+xIjxs03qqzHSYJxv2MFB1zgAcFmYLopva7cMq8WgjLGbJSv6ahC0q1/F02nKFFAjk02sWXd23sPkK7c7CAF4zqoJUCnlPiPzmSAVOeFp+TkkRmEMKnK6PWj6dr84SP0/ddy6B3jh0rJe0mEF2Ho2yhOhfI6G4TSxD7Qd+VCrInwgw4ejZ+xvVTcbMMrZtiVz6BA1RE0yav32vJVj3KJ5DOKPKLDLOk1x2afPQogOHSHfb4IGILqxUItW8C3IISFT+qZRDCgTHV6UxosaXYPs1dHIzcCBon
 NNGjCgPA
 KOXmc+l7kEzSdv4cA7AUrJ5uqgJGtKGneKpvw9Qe9sg+eZo66Mn+UnHYfLrtyguF5pYJjJRNbn3ixswPrQNmoX7j0uuCeZazYf61y6XRCmGHcSc+ZmVVHTiYUYT4AR/h7EayGdd8+4M9ZPYjF0EMqoYm29eUj6OmBhFoLfalMC+nzh4T5RfVKQINJ0dT01vjtrBLx9bZaGqdHXKVEM+hg3Id6ulNKh5jf++VPy3fI5fnLmK8vIYqE6t3PZg+ChjSZGHvjOnun416e+C5jy07V4WbszDk72tEclJ07QZM7OnYFrqJdz3ueFhoELW8rILF3hIuqedppVATzOrEcAhdb/yq6LrDxJLrg7cjC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/10/22 08:08), Hillf Danton wrote:
[..]
> >>> Given lock like mutex, priority inversion happens from Monday to Friday,
> >>> but I wonder if you are inventing some wheels in 2026 if proxy excution
> >>> works for you.
> >>
> >> Reader-Writer split is a foundation for further improvements (like
> >> singleton recompression stream and so on).
> >>
> > But that split is not needed at all if PE works, yes?
> >
> 
> When the number of locks and tasks grows, I have increasing difficulty even
> describing the lock chain that you in combination with Brian are unable to
> handle. That is why in general PE is prefered over whatever wheels you can create.

Hillf, if we reinvent the wheel then I'm very happy with this reinvention.
But we don't.

There is not a single reason for compression and decompression to be in
the same context - they don't share a single byte.  And there is no
reason whatsoever to serialize them against each other.  Compression and
decompression should have been separate contexts from the beginning.
While serializing decompression with a PE/PI-enabled mutex is cool, not
having decompression serialization at all is way cooler.  In addition,
decoupling compression and decompression leads to a much saner recompression
stream design, which saves considerable amount of per-CPU memory.
That's what this patch does for us.

The commit message probably can be better, but other than that I'm
happy with this series.

