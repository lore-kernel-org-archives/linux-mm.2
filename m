Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B975FEE20A0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EACD46B0089; Fri,  6 Feb 2026 08:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AAD6B0092; Fri,  6 Feb 2026 08:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F2D6B0093; Fri,  6 Feb 2026 08:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF8ED6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:31:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C1BFB69E9
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:31:15 +0000 (UTC)
X-FDA: 84414118110.20.9C03355
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id ADD971C0013
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:31:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="S0/E+gGo";
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770384673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Di9rrCemg3Phd+bFA7xXmyQkZ2Pz85YWhx7g/X7oYx4=;
	b=MV7a2A35Xny65lQ5oR4lOhFMzm8gzev++hMyBTYA0brG38sKnDdI70uoU6rQZqKVQQGbzB
	ste+ZqjeNpxNdX0FHpNwLXH/Am6JQDUX8FoUrz4cpSD7Y8bYrP6NtPMeYoDUX+ooR4A0t6
	/lSdm0evvjErYyZAsIXVsSTuVKA+ZeU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="S0/E+gGo";
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770384673; a=rsa-sha256;
	cv=none;
	b=2mhm5S7U1waSUU4FDzJRZnKHd+onmVABGXkOAkPA7fUVlEPP5nUDZaKlNh11rCp4SiMo71
	OM+zucP7V+TCDbPM7nuBSBU+7qm3YloCAcOHmqMhRHvpiWZmGMP3OzFN1Cck3KIe+/Gze7
	X9vshi8nJcMP5RPwucUV6hHADBkrb7A=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88a2e3bd3cdso28694606d6.0
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 05:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770384673; x=1770989473; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Di9rrCemg3Phd+bFA7xXmyQkZ2Pz85YWhx7g/X7oYx4=;
        b=S0/E+gGojJ7tS8ZV1snTot96UvVDEeSFeTWwgR+q3f+W8acbD6BOJTILX/16/SoWhF
         MD7rmuh8IJEs7lSBW50hCRaAjUBnnwzVaM8Erl/hIv+WYzwbaia/FYz1NjSTw4cAelPO
         pmpmFYWwqZKNbN1+D/s5yleVlOISLjumDBWnq2oKxjPEOEn4KTqiqDrz66OtRMFB8mro
         LtkehX2XUucjBe7XfeaGgObr4mDK4pzLUfASd+YlffKBt1EYjabgITO07W+9QlRed1u/
         xLdApygE5aCNkkQwtJmUfMIvZ63T0amgA6QcwmvXfvDcofeAbqBsYKrsZ395nnm5ZGK2
         xHeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770384673; x=1770989473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Di9rrCemg3Phd+bFA7xXmyQkZ2Pz85YWhx7g/X7oYx4=;
        b=rPsDf/DnUdfkOu5gNdGA/JJCyplY4xWuNsMqil6AzTjNnmr6sFFayhmtuQnN70VFWc
         tqC5TUeXCyoZSY9K7KSKS5BMz11VkGXQ13KywJ0n+zbW7+t9g1BK3OL69lT9mVgiIIsy
         uDJzQU+WgaNH7HTCjQZ65qG2w18vjGod9yc8/rdUujTLFuctpW7pd3tZ8Bp5bLZ+PJGB
         oXgPpSL8v9XHK4LNlWcrO/E76pZhVbmxJ6aYY0DXB/wvY14JGuGysjMIGvGB5+urXJva
         yeVY2Ld+Dg9WEuaIosvRShzUrQZ+MBKeT8kqCVCW7MJvMhuMgoXCGQ3VYB6YUn+/dX1t
         PyMg==
X-Forwarded-Encrypted: i=1; AJvYcCXlaZewK89G3pYqRKrZU/FH0P/RdvQCmzDHTEsTkz3INPCEl+eynNzCaKmfBWE3ZBUIkoUm6GxZ/Q==@kvack.org
X-Gm-Message-State: AOJu0Yw7FAEsyGRFAMgMysb1qPBdf/N/za4Vd2AzSqF/uFeDlE5hXpcF
	fTp81CEV0BThidH3/19Unq+FXRW4FCkxsiljkWAJM5ZLR8Ul+AHssXgLopzhZBF/88o=
X-Gm-Gg: AZuq6aIO9iTLxStOlHD8aK+JuLYoE8ewwb0VoI/y32gKKJIZYYqbPYwSyiNCzE1NK8Q
	AQAe/KVo56WMgSxBbG9fh/yloa/P42O4misNweux6IHjaTM/Fhem0R7g8iEXd2e1nhE9C7QhA/y
	I8LNSb73MUzovGf6644qvJWSNIBpx4K+NoNos0kF63+SEQ6DuYsY2Ash6BY+INxve1fGekklIZG
	JghJ9puYuOySn7m9Sh8y2/ppa0iJAGzCm9fzoKl2FB+PUjwBIuOeBG9p8eTfIyY3YlkQAyDV9q8
	Z4uDZa0bSDjp6wtP6gbFsHJvRMxh9OvlauHxylJh3uaPVuI0G0oHZqUJls8dy7esNWExY9U8M/T
	gI9UjZgiAmYojg8j5/Or/RUWt6SvWMD0KDJauWZzW9d9AUZE6XlDCxNk/4zS7QJYkanMbSNGPKG
	vUYo/EKdS04NH/5t+XjGtXw5NCLYmzgH0jbpqc0f4mbNH0MzTUrj/zM6gt7gKBeG60K2eQGw==
X-Received: by 2002:a05:6214:2428:b0:894:6540:9112 with SMTP id 6a1803df08f44-8953c150d50mr35637556d6.33.1770384672493;
        Fri, 06 Feb 2026 05:31:12 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8caf9ee9fbasm152145985a.39.2026.02.06.05.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 05:31:11 -0800 (PST)
Date: Fri, 6 Feb 2026 08:31:09 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cui Chao <cuichao1753@phytium.com.cn>, dan.j.williams@intel.com,
	Mike Rapoport <rppt@kernel.org>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-ID: <aYXtHa4Y2y_5xgcS@gourry-fedora-PF4VCD3F>
References: <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
 <9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
 <20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
 <696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
 <2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
 <aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
 <a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn>
 <20260205145842.efb90572a902ae4c481e6ef6@linux-foundation.org>
 <aYUjf0OrD8f_bJCy@gourry-fedora-PF4VCD3F>
 <20260206110305.00001fbb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206110305.00001fbb@huawei.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ADD971C0013
X-Stat-Signature: kyu6k34ijg64bsyfr8ebt1ss58dnj4ot
X-Rspam-User: 
X-HE-Tag: 1770384673-627070
X-HE-Meta: U2FsdGVkX1+e0QCk/NndOZEm9k7FIg79TcNO7lEVhM8VRQvTqyZ1ZTnHnJpsu546xyb+XWO1/r5kYX5oXoevNNjJytBx0gr+beadPNujmKKGZQTNALuixLZfXDmHN+73UF7fTx8FzrHbegIT6VFqG7sKQOrNxgJ4429phBjE2FMqRJdswkIXETG0HHt90W5TzVSppcI5tpEuSioVIG+xwC5G29bfKoC32eDDaV2ZCAkgHeU0sZOjBcHhoSkoHlQsHzZeawpEl1jIAMvqTkHeMAoXEdPym2qGFYwQuSb/KOV2rhWFrgvhNfi71u0t2B+p3mI4xiDkMwwas91M5bnY30Evpyd47TA+z2T7jn93CsYpUBtniiPKhmr3WZgV1izWVHD55ShKRUTtniwToDGn9zKjlJaghWJhWCJ1tXzFZa5yDm5PiRT+6UDMt+qg2IaKy47Ddk1Rjii++J1zNfvcM8HlV6Q9ahXu+m/SqzaYyKfEbwRBHq7RJXPcNIqrOnJZtvpR3zhfq+9JCR8Jjm42ZO8hT2pXV+sLCq/LBAx1v/roJnm5SHYb+6Hnlp8mrvrw3cqdybs+J3evmF/6vRRG97L2bujxL/sefIgJARYe9+rmQk6gsRY9z7Tqn+St3iqhHoZKyzf5LlQZRDZ1//oFIen5V7xR/TFCv3kAGl2xQ8xFIB8f0N/S8EsYN0rB1LIkN6i0Oho1zqNiy83Mhj4gxvTnFPrOwH1qtuyqgdaxzgFhWy1whfzGaVmqPGBFz8NlisflFoPPJqK1DeBLKNzoIw/KwbMF4Yh1TRLu75v8SpvJ437iGzFwIrZRpbJodQNwNqtU7Y15Bnd9PsuyQkyQI6YukG9Hv56OIKpy9EwVIG3RakQJwVERC0gocAqX5PFLb5/mYXw8GB0QHJJmMwEDw91V3cZkVIcyrW/1Fiq2DYgA76raUiNA2DQKzvRJ1nDVS2Pd64VsnrnxuVIRjq3
 We/hPui/
 Sa3VitHf74MT/pqF1T6qBn6ri8ZEEpQdQLL15mdG2gbS3wcMzGbmKwRtBGvFPVydqMKQBBnXWQO2boNqa06bz/1EjvZR06oCTvHA4k535oMmCGJ7tBnWWq6N2RiojWnpFOzR7SZ8T4NW84E8uIKCeQ/nARKwZjDHWgHi9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:03:05AM +0000, Jonathan Cameron wrote:
> On Thu, 5 Feb 2026 18:10:55 -0500
> Gregory Price <gourry@gourry.net> wrote:
> 
> I disagree. There is nothing in the specification to say it should do that and
> we have very intentionally not done so in QEMU - this is far from the first
> time this has come up!. We won't be doing so any time soon unless someone
> convinces me with clear spec references and tight reasoning for why it is the
> right thing to do.
> 

Interestingly I've had this exact conversation - in reverse - with other
platform folks, who think CFMWS w/o SRAT is broken.  It was a zealous
enough opinion that I may have over-indexed on it (plus i've read the
numa mapping code and making this more dynamic seems difficult).

> This configuration reflects the pre hotplug / early CXL deployment
> situation. Now we have proper support in Linux we have moved beyond that.
> We do need to solve the dynamic NUMA node cases though and I'm hoping your
> current work will make that a bit easier.

If we want flexibility to ship HPAs around to different nodes at
runtime, that might cause issues. The page-to-nid / pa-to-nid mapping
code is somewhat expected to be immutable after __init, so there could
be nasty assumptions sprinkled all over the kernel.

That will take some time.
---

Andrew if Jonathan is good with it then with changelog updates this can
go in, otherwise I don't think this warrants a backport or anything.

~Gregory

