Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84025C982DF
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 02:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4AC6B0098; Sat, 19 Sep 2026 22:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6246B0099; Sat, 19 Sep 2026 22:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594A76B009B; Sat, 19 Sep 2026 22:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 378AF6B0098
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 22:37:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF043120394
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:37:40 +0000 (UTC)
X-FDA: 85232579880.10.BCAB80D
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id E772540002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:37:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HnrkCZfw;
	spf=pass (imf07.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789871858;
	b=36ZFuuiKwGFwu7bjFII10E92bGkD4SEb5Ivp4S9XploX3/5xocaLI55XN7U5Tk6kJI4Bon
	5hAjVGbO3/5c4voHn0W9x/sJQQmarQ8D0ZcGUVL68va62L+0qxBQdG4nG7pRZxXevgqmVl
	nbZIigUVly537BZXAOu20nmr5fB6sbw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HnrkCZfw;
	spf=pass (imf07.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789871858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a661l6/McfJBsW6ih7SIBpxNulf6pfTW6jSdeP75Wo8=;
	b=O/moPax17mNXW2CBuF4TjDI3Uu9i57IszyRBSeS4hz5peUy/UWbS/jZrFgj4EMRqi+b9eQ
	kJyLQD5jA59g7yPVtLNJinhQMkcgupr6HRc7yRhxivZEAR+YuxKPvvTn/QhaGFAk4dYgU/
	+dGn7GYqyKojufXimiIiEy+ahM9F33M=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc433d52421so1053630a12.3
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789871858; x=1790476658; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a661l6/McfJBsW6ih7SIBpxNulf6pfTW6jSdeP75Wo8=;
        b=HnrkCZfwpk9S+vLQdGrlytyw7SXC1b5hQxniYqtYZH3iUJGfXHOVR8Kd7UDqBkQkuQ
         vUocsgio2mOtkW4lOBgCBN95uEei8sFmhBw1G0jG8Nvd6KEir5Xim6AgvLLwTJCI2+iz
         uOpap9Nqv6UfEHvkdcgJ/KUomVpcH17z7rAu0BhwykQbnW0O7y8r/3ygOlNrDB7rsibC
         Cr4wI4NkYrEBpyTWHpMPG6Mjy+gYX7+RQ1jGEtQvQ9bNvkOhHc65B8vRTNzqnz+cZA4t
         mltZGEn6ZQSaq5FQskA4RonwuzunktrKiVnxwr2MWohDi9ZqRYdjCZ3Iqb8O3rnjBNMS
         KaCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789871858; x=1790476658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a661l6/McfJBsW6ih7SIBpxNulf6pfTW6jSdeP75Wo8=;
        b=BZgKS+pEpAzeu6/4K9PLfLVJJsigdkYdaRZve96GQA67LXfehQSZQUI1IteUV5CGlo
         SpDKgoA0fBMy7rnTZyi1/5vQJJKwHwuSJR3saaXf5G/h5CEBCIs6F00XJ+6go0Ffmmjh
         pTphPnjYFJ4Fmb0OATRHI0E0o05srohG67Uei4S66lYukh7OZHVJx5aGNxgc8haCiY7E
         Dpa4e1JVAHKK63Q3o5DfaqtN6qGdEbafBhqIbiY5RNfW6oIH+92U4b62En5CDjmpGHbS
         UDQ1OMG3Ww0Yh3BWDmNwE0wN/C+HYNiJ1g14BQ2AUJ7Mi5qQvuqYQgQXLHRNjh/wsuvv
         RdrQ==
X-Forwarded-Encrypted: i=1; AKwUvBw+A2olfOGglT/CiV/rcjx/yuLs2F7atnSVW1sMNvFB62qCsi8UTD4GgzAB5/eAJ5ZLVdjhbiF1hQ==@kvack.org
X-Gm-Message-State: AFuF++m8fOvz4Dz7QahCd70ta4BIiG7K4pkS2VT5lQveT86TOMOWmYSV
	ie4Rb53usF0YVl8AdqGKroE/QfS+xdE8ltod96LBalAgdEWX97YFpmM=
X-Gm-Gg: AYBFou3W8OOvPf+FwCAuaDyN9J3J/9DmAnerJlIkoqWYri0KuDZ3iwkOyTHZ5jsVD8s
	L9jmAtNbEcP316aS51PAkVGQ7Ew+qjFDW+i6hdBFFa8oPUTnVWLxGscm4wrAEIBAk5PUaJplk2S
	eNpN1dUdPbMYDMRoVAJudasthsgwT2gWGSsWwaH+gRXGobqDSTk+Pbq3xMPDZrGSojqN/fGad8N
	HPYPo92q/VjykOzatUKDNR8T1wSrnUuzwT2dN0sXJA/a9plA7t5g/muyy9+PzxapMpsZmDVAD/G
	s3cEblu5Ip6b5CB7aNdw37OAcMkcs5b9rhDV/d4LPtf1h4iN9SiEtDSEV3vwQ82yL5zfmAOWZ5Q
	pHm1IaYbCIFxMnpFBd3lPMde8UaI3SXWSQn6F9UbnGGKSvR3nNFak0sE9SpNWJPX3CFCcwj/ehA
	6yR0QobeCxnZsAjoU1pKnQbjdhvK+Qg9ZakmiSUWGJIVMXGZsOJnn/UVSfYmVYsR1/euAIasLgc
	LHVStnu5m/4bjpMaTdjZsncng==
X-Received: by 2002:a17:90b:5287:b0:38e:7168:281 with SMTP id 98e67ed59e1d1-39e54ce361emr12233813a91.10.1789871857656;
        Sat, 19 Sep 2026 19:37:37 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:36d8:54a:e0bc:3e5e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37c8e7sm6799764a91.9.2026.09.19.19.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 19:37:35 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Sun, 20 Sep 2026 11:37:28 +0900
Message-ID: <20260920023730.2468388-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260919165509.86678-1-sj@kernel.org>
References: <20260919071324.1583280-2-donggeunyoo.kernel@gmail.com> <20260919165509.86678-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E772540002
X-Stat-Signature: 71xbhsypbxcjdhehe994s1admn4ymwre
X-Rspam-User: 
X-HE-Tag: 1789871858-251914
X-HE-Meta: U2FsdGVkX1+563I7pqSW18yjmyIceXIYCQ/hwglx3PKsE7pqm3ZWQYyibnhCM7CSNlXqknZOaZvqFypdmQszGGkIxD4Orgy13/u20EyqTb0czjWFrGEVXLS6kw+xfmLT099a/PZW4bfut/AM6tOSVqrbjzq7VLmnOTlIqCGUzKxeDusDPposoF/57yCu8yOWElevFYcoiAOChwNTeuLZHfC70LNznPFDw+kV9olJoVkOWg1JxAzQgz9qLVop5SVmVA54O5Ax+DkE0bjx/ZDdHCFP0sOTgd+INxKE5tLo86LY0BZqCcVhT9b0r+AgLreoYSWXb9AWKCSdbpctJMS1JcKd0korCDFjn0ye8YYsUW/dx4uMCZH3D1mhI4jIVCW1gYxW0U2gHRsrQBF+ongoJdxxRCye+XVtUFlswLw53ilvBIs6eXA8SIBXoeYc6XD7/mQgnWawnKcgGf3AN8XUWWeUQuVCFoXkD/+ZOuy2u9SKSJvM1kWzj51KCX6PcSmaS32QhZ0Hnzm4/mCREIsNcAjIQS48spJKuzfLYkIBviOnurc7N0DfVZge903czx6SLxoMNt2ko9LUhgROoSXrMiAT/93XoHTgM5LI4eMeEPDokznWG7TjqPkPxDuAlCtLDNaCQ7+WF4rU6U9Sy/3xeYhaZBh21V8gzuCh6/+2R6ikNnTqxU75zKu0X4rcmvP7owtn6R9Blw8d2cs9whbuqADh3/+XWyAKG+DquQyvi+zQO0+3YddMOawyCU/yjE59WMy8swt+raBFBM/+mzBMRFpUfohpj1t8Oa4mwymHuqR9AV5uafBdeR8vOL5o6PeqFuoH4VHTIFUbCCDiaTGTmVBYxvkIteEf9ZNsFqQgVzf/b2lk3yY2Vd8MF7N0iBGf83oIvmCCK8UoWUruNx/I+nNAwhg4inybEthflzrVelHW+O213kWtj0wLI0p3TvTHtlphNGkhnIym6pmptej
 HQkoTX1j
 2vIAumNFeV1YyHef/G26pYCxhFQTDUjHMLXJ/OxAAa90iG8NOhAXS8ThvVE3rM/3cCsBvOtyngVKK/RItgZNT4aaMQaeZyBF1MZlDve1GeeWogxLZlsYrvPS1SdmcFXozcOlyv6J51Qs72bCASorNbgy5g9uPaomxNGm8RjG0xvcCM+vx8IS/v5hBgYN+PUIiCcm9/tdXNpurJ668rycSQWzxDpR7h8zT+kCsgQ2hEIhpcIE9Jk3vltcgyxuE84mS5ytSdQUVwpkrk5h0vuiAjriyBUBdoPEGgo8mEwD4dB91TMGMKG0/AYuQeywIEhDVMvf5zksTWXNMpb/PBUlBpRO5/AptwU3r+lXjn4YzHdSWrJ1LlZJmvIthzrJRQdCctZtv6EHDD7dFlkZWXJmQ2oQW9snWzTNeTxakmovkOPGqOz96fOV64IpCRQG1jTdnoFwXRPQCWhkj65yVAra1OLAxUCwgM5JKXrnJimdK/8NwvUuXDebYWwQgJqIusPQRy10R5+iiW0mcASY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thank you for the review, and for pointing me at addr_unit -- I did not
know about it.

On Sat, 19 Sep 2026 09:55:08 -0700 SJ Park <sj@kernel.org> wrote:
> For 32-bit machines, we have addr_unit parameter.  I believe use of it could
> effectively solve this kind of issues.  Correct me if I'm wrong.

You are right that it helps, and quite a lot: with a larger unit the same
amount of memory is written to quotas/bytes as a smaller number, so the
boundary is much harder to reach in practice.  It does not move the
boundary itself, though, since the multiply is on the value written
whatever the unit means.  And as you say, only paddr implements addr_unit,
so vaddr and fvaddr get nothing from it.

The 64-bit case turned out to be a little more than theoretical too.
bytes_store() takes whatever kstrtoul() parses, so a quotas/bytes above
1844674407370955 wraps there with no scaling involved.

v2 says both in the changelog, and your suggestion about the user
documents became a third patch.  I also took your form of the guard; it is
a one-line diff and it reads better.

  https://lore.kernel.org/damon/20260920023111.2466265-1-donggeunyoo.kernel@gmail.com/

Thanks,
Donggeun

