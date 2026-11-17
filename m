Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B270606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ewtveVi8
Received: by kanga.kvack.org (Postfix)
	id A00336B05B2; Tue, 17 Nov 2026 00:07:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0DC6B05B3; Tue, 17 Nov 2026 00:07:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89FF66B05B4; Tue, 17 Nov 2026 00:07:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18CAD6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:07:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A12AA16033E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:07:45 +0000 (UTC)
X-FDA: 85443428490.12.960DD34
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id D6BC7C0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:07:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=ewtveVi8;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf22.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=erZtH4IJMudy7WQUbT7BdWCH9j2OmGrPuCsVrI+Funw=;
	b=kZfHU7lryT1iueSER0zKVx/nycQfYiTFzP/2XgiVi5E4c149R9FXnfZoKUPASwDVaNJOme
	hAKZsJNuUejO077srUSBuQNbEHMAnqMDqfceTcnRf6KLumCXO9+bTXXQWnwQ24jJ7gU2Ff
	lFgnyKm1dffmfEPGrJTDSZDSACTDJso=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=ewtveVi8;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf22.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892062;
	b=8HrQXm1rRXjvQOBZ3cBqvyYlikmKJQ1jy1y0IDu7TZmawZtamJsrB9IzvHkAbvqyKTflox
	/VNUdFBgs6WfzdUhyC05aLshxmuu1g91oCcNJAbdEW/hrp/g28D4wycs/VCUCQbCaI/iRt
	YqFBnX/cs5aD3O1clGb/sKyTu70nEb0=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36f8cdd30beso7053108eec.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794892062; x=1795496862; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=erZtH4IJMudy7WQUbT7BdWCH9j2OmGrPuCsVrI+Funw=;
        b=ewtveVi8++N/2zrzmgX0EHPp2GegO0nvaj6hBYgDAkbtxbc1pPdP6KmEsB0lx+kTF1
         TnGAIS7sDTyJWmH+5JC2Tf3mWNJrRbmD3k9owKrWykFVAHYcJIrPitbB2Yr8pWyROvqu
         3t+X135miH+xeQSypOq3zpGDEb3d4Kfyi0iDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794892062; x=1795496862;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=erZtH4IJMudy7WQUbT7BdWCH9j2OmGrPuCsVrI+Funw=;
        b=0+HPJA76R3n0W4mw1f2qak4fmxgqoSH+Yv6NLdYqp6eoYJ9FNhcEFfsi2U3u/oPuPQ
         FsTEVYJhLdD7+QFIZmzfmzLr6kQvml67K0Hy47B4IDzpdFvnUv3JFlbbQQBeLEMd5GV2
         Uun8gBfrws7/xNzetWNr190mgcXAp8ywP8Pll3q/JwcC4bgIyb6MfBW3/mbcVpq2WZUe
         ifHLGUDWGPhlXk2nacQiEwRf9DaWE4s6Bs+WEL15UziTn8hc+7bv9GW7NtSG11b6MJxO
         lPUjTsCcjM6Hp6Z97EruaKpUmgr3KetTJhCkH6RNIY9+/MMibL+tRxJHJ0qgDS0fxHTR
         xhFA==
X-Forwarded-Encrypted: i=1; AL+hErGvwXql/ezeX4AYyy4BEHZkCTeV48fKOrqKfL0N3HNuuUNnOxTseY3AkKzTod8Nxc9iIv6Q+8VK+w==@kvack.org
X-Gm-Message-State: APuU4Z9Hxs5miX8n8wSL7s51/dBqzkmk7/olJTNZnLjZPiqHMAm5zIiO
	+gkPvqOcjAM2ozSF39hlqFck/KA3BnBsEO2fI6syW0MxUoQo7B0CA30xIq7ifGDg1sc=
X-Gm-Gg: AZFdTZebu1STsk8oFGyuckKOZhH+YXBxmdKelU75+RJNEixH1HBAezzV6+YpoBQ5M9r
	jwVFf+sk7aRPXaM0RNCCbGmpmYK2Y+Xs2dDyUnMNrVzRUJnAq2qCOH/Px+R9YfccGDPhJTyScYV
	gnpgfi3y0p1087Cr67lNFZsvppIH3HLfX38M+BCrN3ksIgaICuLMeItniK+6B93i9VMmIz74MSB
	ifMHEkM4O9D5LaNSiW2lU7m57xl2EITNmw9bVr/QeA7kQBNA1Pb+OOyXZ33vT+Fp18cUZwDoxu7
	fVeHZpEv3Er0d+rq+iJWPdRJXy8a0rv81OEr3Wd1yis8SZ4IfuuyH/SjT5a4lnR8u+ytGODREXH
	Ty68Rza395WaXbWXnYrdv/mvHbUk1+LngZU18jY8KE3fiUi0Vc3RTos2W6jXniU81WOYpKMgBax
	Fl1ZJwJH6vUvW15XM5kFAIzluYci0qxSzCgcwTVl0730c+msJ7EP3EmuciEiRAM5kkdFMVew1de
	Strs8H8Ov/PZ79NYaxeLSrPzPD72sKamgr7eRFlrtFmvdgBGBgVlOSAPMUM1uHwxnUqb5xjmzH3
	/TmVjktwAr/beC/tV9mDlUDlFTwx2O9BCJ79RrD0DYHx9Zhd3AAREw0+KSFhamX6sXcO/p8I1hC
	BFYqhsqphPQzER8j9Ns/I6RnuMO1BUqPFNIWm/fI/uJ1YGIgolRV+Wns8RoTi0cJD18Y2E49fYZ
	flhbQxEY8KmW/FSynex4HQBh/FxXuepffNyNtaOUeycy7/X2F3Qtt4KHysxGpNLJ5G
X-Received: by 2002:a05:693c:6383:10b0:380:d1bd:ed2c with SMTP id 5a478bee46e88-380d1bdeeadmr2109515eec.27.1794892061684;
        Mon, 16 Nov 2026 21:07:41 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-380e031f3e5sm7128627eec.12.2026.11.16.21.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 21:07:40 -0800 (PST)
Date: Mon, 16 Nov 2026 21:07:37 -0800
From: Chris Down <chris@chrisdown.name>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org,
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 4/4] mm/damon/core: use node counters instead of
	flushing the root memcg
In-Reply-To: <20261114002822.1043378-5-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
	<20261114002822.1043378-5-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avvhGYhjBrOzAmT_@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Queue-Id: D6BC7C0003
X-Rspam-User: 
X-Stat-Signature: zia84as1txiignztgkak3oug6kyyirxy
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794892062-354174
X-HE-Meta: U2FsdGVkX1+YASeGdCHoUE3wQcugC25MyMc1LmpCcIzEsZD6mbU0FmpRyX3tnI4/O4LIGQT5yFZlF4JvCQPhDxf7u40QAH4dmd0NL5O+yEhH/t5AC4Jb7nDMCbpAj/AuqN3GGurjngMxfKKmRgROtV1Ar3lbsNjBhQpcPOJ2WcKgelulmvm8vpHb+b6McEf6DCEdi2WiTS+Fi0CcYmZJudq39m+0byxfQZZZ+phJYD61JaG/dl+2FpcBor62+LSHp7Anuf/Xig/Ea4Uc9qt2NUF5B9kfOnK0Ivkb9EXtrXKkJfVTH2jYnIs+ppSjfSyS4KlTXm14AebO/1G8tHn3v8+HTIKS2I6bGyYI4KN1CSb7UegLO1V9cMmW06oiH7ErbMaWn6OZ9cNLpyYOeHtU1IhAoohPP1Jy1/y964DSzFxx28Lx/NFqv0zab/hA98XgpGsYYmQDAnLo0eVgXh+bhr/splp/MapezE2/HxIEYO7gV+O0G8brv9fERxG0HBIU1TSO+1tgFhZxKzzVgcX9VCzMLTVDlegLyNSurGUrJ0w6j9gKOj6XAqEUlnO6NTYzCgDDIUNqCyD5qdcTOKdm60OHuLfX51XO/wpYW7ESL88ylWA+xadLl02Vyw7hCG5w509lfqBEcSlwzgq1CkBcT6rC32U8p9SHxQRpZ2/FCp8EEORgAzPm3wYTempzlQwGCCk270pgdDWXSm4fK5QTYs7ujsU0jyHaPIFnDrKRihzGFeRlYkfwx4TkSArqGOybB0newLYQKCsP8vlD8XRYk7k4iGUA49/KkVu/gNJuvIMGe1AWgKI8dvThOQcKAVf5kjzvh4erVSqF+N5dYw1l/5lIwTLPjTMHWgcOjF9ScHG4b/rrJPRZ8N8n/BdM9NwlJqIQvSsTz28C3oIgcadfmsJg/R5jfuKWlFBmo1CmDg3txIpqCIjBWzUXVYmgvsSUgqKpqIgw8skgYfvLOkL
 UWNrkrOm
 3AEnGLaHe/UIsBX1EmjNVn8r9D9DTX4TotVcdrgOPN1G/bEmCnk/pDk4BkkjF8RZbW8akpMDi/HpVUk2tBR6pIV1MQuYqwRXclQSmvwZUGoID1PL9Nn82H6gddj6e16STpQpOwd6dNxsypFPlTazHbk74U6egbL8oOunKTZZjaxNJbcUsdKodavX3pqIbnvpa04brP1ACq0LlMGpATzt712giZ0SqPmjdxc5Tg+Ed5b65TDEQLBWe7fUeow/0JbhsowMFEEIWy+9KKQmcuxLVr4/6EAoyOKgUaln8q5uWGjCOdgO1hnAsYm8HQaTyz+4jJm/sBV/OSyprMhHggbl9MDrcvjDqZ/3LqML1yh5Cqu84sSYs8GYlUEWZfrMOV4GQlLDgcZ4sXWYbDZpLW9JoZJuC8GhpJLTD1qvotF14afOvnRvTuRvzEQIhisEbJo0rMbLac+n7HOpbAlE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Joanne,

I've tested that this works well.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

