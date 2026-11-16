Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32034606B1B1
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NeCdcNOF
Received: by kanga.kvack.org (Postfix)
	id 5E6B06B05F7; Mon, 16 Nov 2026 06:27:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597786B05F9; Mon, 16 Nov 2026 06:27:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4246B05FA; Mon, 16 Nov 2026 06:27:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 340506B05F7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:27:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADB5F1C4316
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:27:45 +0000 (UTC)
X-FDA: 85440757290.15.3E396C5
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id C772E140005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:27:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NeCdcNOF;
	spf=pass (imf23.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794828463;
	b=W5SvrRYKJs0hUAzI8tAgmf/RfLhmknt0cbyk1v2VYUZfAUlwfAMtUkz+Fs1lzSzPX3/H9n
	/XSTtW/YA2s41PeWCMItzJX8+S+kO3qbYuWVyIfu9sn9vfgBMCWk/AK+VrNkQuH/cdzcD+
	0b1aGssjrg6uLsZIPFRutBFeyrRUZTM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NeCdcNOF;
	spf=pass (imf23.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794828463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5BStpc8jowDmC9B6cxbOb1co1bGTg3WHKFG1Ve9+btE=;
	b=NfgxehLT8TDeu4uZI2qD1lVC8Zm33JfJjcrtM3FMom6yZvndOUbFC21/B2tg+xCHKW47I5
	mfIT801ixL7ZtZqlZzdUo8saChUM8dc7PmWy+h76S5EZiXFiYGuAlmmwYF3ON0KoizUpxA
	Jt3wtuMMNtu0vPacABK1XfF6Gj5B6eQ=
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3adc0ac3566so730102a91.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794828462; x=1795433262; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5BStpc8jowDmC9B6cxbOb1co1bGTg3WHKFG1Ve9+btE=;
        b=NeCdcNOF/R6qoHxDMWTDtCvQIi16HojEMNtGyjEfDkivzO03PzVhAMK0hotvRmEGGe
         UDgCGyuvN/LbSPhuIwoylxsfIJECh7E+kO28nvXsmADPQHqHO1D0q+mP2Ht9oEsQpWKx
         zSYFKXKqGEKy0ERd91YZzlHTdQuEYb1CverTs3v1ISAbkFYD42bhhyDVjAEPM1+7dCk+
         7GuupqCF2TfFPKs3jGcsvu4jii/tx4IGJ0taQ8u5pRG+Z7z2DG4xor3qauTOvVkzYqsR
         jgrcDY16ZfDXKzRGIal2yqtBzF/jGqjGCBjz1bN7yIX1qNvnXuMUtKJ0j8cWnaX5FlJ5
         FAMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794828462; x=1795433262;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5BStpc8jowDmC9B6cxbOb1co1bGTg3WHKFG1Ve9+btE=;
        b=YbQ5+jKVt0cMDUR5/1YAp1ia8EybO1bUWz7YRj0ieim7jb7OXdyeu4+zDfZVaSgLJt
         0HYB6QWp88Cbq+TR3G20Hd5LYlQ+o5Scn8itpyHvxxT98pCrgneVfK9N6nuyuIfUh4GD
         MkkNf3GfRGdEeKrYXbPijA+OGUHOpFBHzNJlZiYnH3kon0OGq7NIHXDq+8u3InSFhq/i
         zZ1IxNP+qUVaRqOlNrWTZLFxIgkp6kFcwnF4/wiIc2nv9SQg+1JRBi3uqwQA2adDOJj+
         etemAe5OvNczpdrOEND/Otz2MWBycVVbrL0MWSnV7eT5dZfTzhUQ8MUvrVibluPBv9Db
         re5w==
X-Forwarded-Encrypted: i=1; AL+hErHtVBBOpc2OccE1JUKll8Y1tUMzujCP9oF7meXHKrWltIbudjKsd80i7O6Z/6kS17dr0BZfe3uLbw==@kvack.org
X-Gm-Message-State: APuU4Z+xuw5HD1z2zq7KvJ0EbzI4AwYwwKY9pwDPUKtCn3RKdvEo9ZQf
	YqDtpHSaG9RhUMacP0Mz6yE8NpCLfv+V6uk1vrEGGB7J9ofGT8qm7C/A
X-Gm-Gg: AZFdTZeGUGZCK1ZHPCzJXpoyqRhN2rLkAYVs1yO9pPz0Y8loS0E7KYGqaD3mVl0HNDY
	mbE9WoFK0sfrgyYt96uAvfx6a1hEeFkEcsBovC1dbn503H5mpkkGz3u48/JVbvcxIdBi1vorf8P
	AgtXyJnqyHcQAZTsAN4MT6KUpxrmo6mBU45byptHKx+AqVs5XLABdFBTqgxYn/ujU5sxj0d1TA5
	5phrNnFh0F+xIsOtTGoM1GxQeh5S18LM0R8iVk+WvGwW6sdushqlzKAY/cybTUEkZ1SJs2KFKty
	vHwqwIY8Lhkv3HkXduTrACszkp+A0K7drNmz1dDH9NjU61OSmZ5eRpoOzGT4dSSW97OMKUPfmkX
	Uwm7u2aK2hg9JoBFpqUsFW4o4hCHTKdAIUtSZ/lYgyWqsqD/2IkTzXZmqLQ5d5BMaRRnoDdDs/f
	9Zc+cdsgz6gKXDMh8cA35xo0bL6GCKVeM8g7HDXOe6IkodBeQTnoo1xaufI8/n2qoaDW1w+YJU6
	dQcbcPcdvILIvDIThgNS8dffZ6TlFceEf+MCYj/sRWdhmyXLXRrRs2P/fMD7aBRv2K4RZ1N+YkV
	wwMMsH2iBRtUkttVGTTAhONdAJ6Ged32VDCtbHAXOUaYfjcsXWoX/X2EQE/aq9g0tcZL3Cmne0r
	sQ4VNN60NFODqma7q9ah7yzXex2TolYyNNEvlBLR+wGKQLDGC4zW9uYRhUfq+qQ==
X-Received: by 2002:a17:90b:570f:b0:3aa:f2c4:12e9 with SMTP id 98e67ed59e1d1-3b1b0815b4amr10210516a91.3.1794828462318;
        Mon, 16 Nov 2026 03:27:42 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3b110c0sm8411247a91.3.2026.11.16.03.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:27:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/3] mm/damon/tests: add KUnit coverage for age_ms
 filters
From: Aveline Noir <jm5905938@gmail.com>
Date: Mon, 16 Nov 2026 22:25:52 +1100
Message-Id: <179482835290.151538.5686597403158226303.b4-reply@b4>
To: Jason Angelov <jasonangelov@ucla.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, sashiko-bot@kernel.org, 
 sashiko-reviews@lists.linux.dev, SJ Park <sj@kernel.org>
In-Reply-To: <20261116-test-age-ms-filter-v2-0-3b265d59ec98@ucla.edu>
References: <20261116-test-age-ms-filter-v2-0-3b265d59ec98@ucla.edu>
X-Mailer: b4 0.16.0
X-Stat-Signature: dkrgrn33yk7d51keijq471q8hza7zfct
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C772E140005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794828463-58602
X-HE-Meta: U2FsdGVkX1/XQOLAt2J26tumzf+nVM3owJ76FoL4L6RPUIMFQOuZtGVCuFfbK7gKOCsYwZMKbmRvj3Bp19ZBZwgmRoeAAO7ABs6seQ/L4FR9und8YtMP9Y/+hR1Q+gIfOZlkIaYukL3Xt69fOqkYbPpOmpsQjaVy1yTkHDANVFmpT3nPLY4Ut5LEUPKJkO2cL2KIE+wI6EvnIYqr9AzlOWUicjV/gBDg6kje2BpPNICINW9QR5n24AOwLB86fIIm0t/KgKabyaNuPVHcP7D/3mhRCMJfoU6za4IMn25HsTVFW7o2N9V6ggqRpET5PsACunObMUS20/YVZHTFLGlmVkG9uooPh+ZxIDnTtZ080mvYdXIreK46GQyPW4vqDlFdZOwzyOdLvuAp3dR22EGpTtcF/KHvY6huF+4h8a/m77Bjy+JBLPeHYP3PA4eWnAficaXDjtKW+Ge9bAOWja+Z5hNLUEB2r3YxwCRzuLsr4X7EgVFdDnojxAn95uD8Xqc8yhaIcxo6bz7zbS5xn/BGZFWmS5440/r+i3oDli2NpCj5tv6zA/J6zex4BmLv7/FheGwLAa9iVIdIsMB0HxHmPrsZ+Iw2HlsbCe8IF6n3j7oFeXT61eFgVwNTxBuO8zKnlTXg4oia1MvZ3n+xJ8WdD6AEDFbTvIlC55CJhvloNmagEDSPOKi1VKkUKVoB6IcpeSic0JJhAHPaYkLIq2evyY6RdsORtV9TrPSZ9zn1EZnDZC0RyClxPsPbKwUW80Gcf5GxIKreu/ZIZo9XmU5WYR49hqxWaezk+g7Vf/Mh73lf2RTaYCcZ6R5HEis2CbcC78lNLGoT8x/H47iETkDr8epK9/UkHXwjkI2vw0ekUmm9b678aY+SgDlp7V3sHFR7Jvs19YlEsB3msjLKs3XBMJhPHvxRKEd2KlosMQTcMInKw6S1JJfvM/A/RxoNfJOlf6dpFrXgm++0JxfHHX0
 QSIkGkPC
 PTQxpOMRza1n+0TSc8SPk+wJDbPcIIkG1x0qVsB6ecLGeTAyhK47aq1WJ+GZpCrdzv95GO77SDBTi76jQYShpAPRkhXAE+QQp2XKv9kGZRQLFZBUL4MMBChCcxnyZutmjorf8dqWwwnK1VhqC81NM9zFpMW/MW6uzVs8kfMmDWJRsvs01UOX74uXTbuE/RloeWbh3rBYv/hrDfC+Xn0dvr9JVRm3wkzNRrzSNhPqSDUc7bbHzmhqWqFFtO6FASSmCLylPqcawexwYDKNPvddyTvMZogPp4xXjTzIvHy4p0r7LjYoplPrtnLtoVFRHE3Nv+LgqdO7GtEp8XH/LKiXYmNUsh+0aL5qjsuv90s8AKFsKODVCQ5Y0rF7+8F6IyLOtmGvZJQ10/4JvVJQwFkPZWRBoDUTscJ2ZYoxmtYY3q5oZLiR1uM6Tg/nIbwfEqxPo/+s4BDcAp5U7RVx1Ue44orXW5e9ppGPUmaDoWSoDBjTsih0nWQ5D3f4hQoDrqf6hCtLc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jason,

On Mon, 16 Nov 2026 03:06:20 -0800 Jason Angelov wrote:

> The DAMON core tests do not cover DAMOS_FILTER_TYPE_AGE_MS. Add tests for
> committing valid and invalid age ranges, identifying the filter as
> core-handled, and matching ages at and outside the range boundaries.

LGTM, thanks for adding these tests :)

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

