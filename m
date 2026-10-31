Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DED6606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 04:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fyZbN5EE
Received: by kanga.kvack.org (Postfix)
	id 7AA876B00EF; Sat, 31 Oct 2026 00:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B916B05B3; Sat, 31 Oct 2026 00:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671DF6B05B4; Sat, 31 Oct 2026 00:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40FB76B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:40:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 450E7120833
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:40:57 +0000 (UTC)
X-FDA: 85381671354.09.A07649A
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf06.hostedemail.com (Postfix) with ESMTP id 777F4180002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:40:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fyZbN5EE;
	spf=pass (imf06.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793421655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYAG5OYgNALKbmlFXyHbo1nyH/Yr5PiBp4YedVqYig0=;
	b=uXc/K6Qz4EkbsS3uzgfzuh5Dr6VpE+2y8bo0Zf7b2O06NAwjIYYJPuo672Q1IPoFCjpnDt
	uksmLXRMCt+m39pLmmYzQFBn6OanLNF3FG0MuwXDZs9tuMchhHrG5ZqrugDY9T1HRf3L/f
	omVzM2mm1PfLOig2tSyWlzml8uvaJXo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fyZbN5EE;
	spf=pass (imf06.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793421655;
	b=xD5tT/xPXPQjuLw1FNpPBGvkM98Vrzyy4EaZspKnNmW30zvULR975sSmBx7ghI18+Zyr7V
	HOzruyhuetloQpjaI7Oi5vqm9L/a7gD1SMScuqDLO5EXaGYivifMNY8R1LSKUgyOhkT2b4
	D701bgFz0C8Ep3dTG/IBKYAF3B61unE=
Received: by mail-pj2-f8.google.com with SMTP id d9443c01a7336-2e93d9c7973so12488015ad.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793421654; x=1794026454; darn=kvack.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:message-id:date:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mYAG5OYgNALKbmlFXyHbo1nyH/Yr5PiBp4YedVqYig0=;
        b=fyZbN5EEQvHt214yF7NCbsLa+lhh9PCnEKRqjj8inGPOPA6I/x1lkIYvlFutfLfG7Y
         +mNUZ3juAfRTa7BoXjKNTVH3C44UIC26aGeZQu0b4XnyCzLGn/3xR7YE9oPBE4t5UjdS
         bJn2CLo6mNUmf3x3n6Ya07bpfwDnROrCehnPv3bcGTlcInuOPtNx+nda3Gr95N3rL4Hp
         IraT0vPoJHlBiU7GWakAErIuXfxkzdltgbJOA0gvcVtpOLobGF1varJjSlRO0mUGVEfw
         5+BCSGDdSAxN1l192gIYpFqjTVxBiH2AafpS4WUUUAos3Xpz7N2nVJ/lfZjYEY0gTY8s
         vt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793421654; x=1794026454;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:message-id:date:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mYAG5OYgNALKbmlFXyHbo1nyH/Yr5PiBp4YedVqYig0=;
        b=v0hnj5T2SZgMybwDAjgC/EecT4DndVLl8+g8RozVNU/hn2fkjEXnC0+jzodI0tH5pg
         L1Q0FKPfo/o3v3PZGRrf8/MMlz1V7AMwOBM2RGPjsJRK9eNJPpUBMc/8G24T8krJ1hGQ
         6yJAWDL865KDtJSA4Imvpvfa6HPFNPSjwICwpsxfYRAW9VjUwG8HDZBa1jYEHwOnwAdV
         hEadT8AsAoC0XIkkiWyQZ9vHhZQqJCRth1fsV85pfGsJBvsu80PLOmCFFCm0NK03YQsy
         dgg+vSUcb6nMVp11fkjGyaMfcEwXTh4A/vVkSfH75saoLJyK4voeOIJ7qkWA7TyRDqvk
         ePtw==
X-Forwarded-Encrypted: i=1; AKwUvByjlbaQFPyohPbzKAN0L+POYGA5jy9WlWqqW0tjayqDXeFqXFkk2eRXIg0fNyYL71kPYys+uQVR8w==@kvack.org
X-Gm-Message-State: AFq9FYJFSanJdBJlQOhgebDF2x7FZTSQuUdRxg9tKAYT26Z8hyoddo2Y
	VK7zZfLLo5HP2WKkNu0nRuH6hLfj1Qvn0vqdjqYFd3u6JNugHZa6552x
X-Gm-Gg: AYBFou0UFrloBKWDZaq5UnzkDaF5nAmRQKHuTGiJXuiuMkGPSpc9j6TU4PwSfX49EGk
	ZIDgoTb7zw6fnW1P87Zn+MT4dwhyt6qcNVqefztI8ZmN9Efe2OoTLZhTuq42znOkM+Yr2/VuPtL
	x7/P2r/KeSYUmsyypoe27uska+a3HDUSlT9dj5wyfV6TRC4xkan2izQOplBPg3jsJF/EBc1FYng
	EIxeI2qERLCHoD/PnQYvjyj803xXzdFUcY5aOEi+g86egBau1amW/0f4b2LElbOXrWxTwWz/gFy
	knqb9thIhIxnXGL36vkj1597AR/gwRA6ye3A8WBH5gGV0fRnvd5E1mAfWASrMl3v2e/31smCTdf
	8Ofdjwd0eVO3yd3CZQgkIbBAhjqYm4eKBDMFqm/J78UQM2c7KI6wpJ3r+sGc6yh2hcIAwwzoxeG
	3ucGFpe70P2gwSN57LLPGGSez5pS0S4STOjtLge7J0jmyLEXvcsiiNGPSwfDX7L88t71Or/+fAT
	kx+aGe8M96bY+PQFM45s/KgyHgzLcy1WGfxQQhLUEajfn2TuJavJztuZoRdF/Yrvo82G9LrA5vo
	0PX2Ly68hSkwTsahen/Y5mYD3mQFwYrVhySOcCKHsLEDsX/dIosBeyevPZj/TGYlkklvGqVe9oK
	o4pjaCFkpZ5Iz0DUeR0jLs87gDa4Ngf3hU0cH8+YxCVJv6TA=
X-Received: by 2002:a17:90a:c88c:b0:3ac:d79f:8229 with SMTP id 98e67ed59e1d1-3ae8984cf7amr3599348a91.61.1793421654153;
        Fri, 30 Oct 2026 21:40:54 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae8454327esm6093012a91.4.2026.10.30.21.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 21:40:53 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, sashiko-bot@kernel.org, sashiko-reviews@lists.linux.dev,
 Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org
Date: Sat, 31 Oct 2026 15:36:00 +1100
Message-ID: <179342136087.2.16978105493403840270@gmail.com>
Subject:
 Re: [RFC PATCH] selftests/damon/sysfs_memcg_path_leak: define ksft_skip
In-Reply-To: <20261030044643.157105-1-sj@kernel.org>
References: <20261030044643.157105-1-sj@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 777F4180002
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ko15gnb793y4brb5u9emjuf98t9iugmd
X-HE-Tag: 1793421655-209434
X-HE-Meta: U2FsdGVkX1+KwkLIquJFr1oHErSn1P2yiMUW5Eam/scD4703VKilXz1H3lyAsVee80qcxRPTGpTnhc/OCx3TOktz7dY+7H0M+YjeI3w4Hn9k5kbKWtHzJHwwFvFpc4ZPEDUnRNMIwR+B7AceSWlUtcm13hgpbu1QLmYTEmk1Jye0wflntttH8QRzLt/9msVvdbjJ3rRMUjpST/3mjTnwhdk4v3ZA295c4AaW2s2+0uBWUXkjl42ln/f3SWMNekrJV3mF9/96oFK+xczFzFth/FGkNyPp5Epxn0jqGv1taBRDWLoqZFl6AalDlxLpqgtwe6z0g1xdX+9jAOKkN2abcWinuT8W2G/S6VsE3PGKBoOfsO/bQEsVCp7o31viLty1wH5ysStMDvak+NjjaJaZaAZhUCCbawDRC2+f3qVw7ZAsAt4Ba9i1rtYWpCUPqEYWo0tIwqahjoZQQ+7FEa+qnmqwJsED3ZxyG7sVEb8qDmE+ZO42JHVXj0Jr6VldNNqajCOflpxd83btwQlNPgz1zV+X8qolVl1SDPFCbWXimkMDhsbJBjm7IuvQQ71gOctSPo3H/eM86/1g70iOlGYrLQOFXdoVFbS3IkSwyN51hnSmpMTskhZ6+FNRYXaiM7eMy7MNtJwEc6l9rLgd/F5ePt8kZ1XdL0FhaWWwfsCNLFH1bNy/Q5N3uVodfAnrzVG7CQC3ChIpSb/uP59OmD8wPWfcbyqUQGBFbcvdxIWAUJQdnJu8FE/uRCFjlRIDKHjdzWl5lfQjmbhrqLm22QoZi3vU2kbgafNbsTaN9Q2Q8eFK45HJPKOHfYSwDfJsi+L7pJTZ3dpT0Sed0VYNqiI30kQZzDikP/AKKLOLbrUW6mi2sk/76JdV/+yKUR0iea46RAsXbeYSJtDXyQowmLYw++cLuL1s07D2mDngbFXkoo9iG/kfENv2ENI8WEYpRpIl5algc3y1lpzFt06TMvk
 vEzwTPcZ
 qRD+P/UXm2lO5KoMg9JlO7xgbFC+4ikmmXHEpnWTGtwVghmklzE/5Mkw+e3fJypZF+Pv0n7S+WtngnO+gp9KsQBgKHe40VNhrLUJKcwCz21nkfGvzcrHmHhjA9LAFkJ+g8LDzXp42MCkywwYxGBH3Pt37ChD4B8PcAS2OW9HYVsUzWXQzqjrDWld2vywqMIwqCFIca0BIiPaMwsHoRh4O/OArOvVbbKWfpvvBQlJnqC7uUmhQbjqWcCxa6jFaelPzUju8L3ntaZxYGQLPv1m5iWZWk3Hq5EXpfJQnxILPHR3nqpq5NwBOmyh5vqCKUqUQpv68HWKp3vobIoLt6TihXtKrlh3ZKtL/teOmEiSZNayf3+DZEJ+5of/I2HPmO5QlxqwhpSuvKJh9fevYJks6zdxJuN8oQKl0+NmW8mSaxG3qcSP0WP4cF4CmoO5d2suTaKRIbotQl9WcnIXJFeMCZFpdCc5n3GgC8Ng0LpAHSD0nQxqgjhXh1ZH7+bg7PZiAqiwoxkoumw0nTmBUYo3F5jbr5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Thu, 29 Oct 2026 21:46:42 -0700 SJ Park wrote:

> Define the value at the beginning of the test.

Makes sense to me.

Thanks,
Aveline Noir

