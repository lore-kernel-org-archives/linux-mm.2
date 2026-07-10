Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A4EAC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CFD6B00BE; Fri, 10 Jul 2026 16:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D1B6B00BF; Fri, 10 Jul 2026 16:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A9C6B00C0; Fri, 10 Jul 2026 16:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCBE06B00BE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:26:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E9A0C3AF4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:26:27 +0000 (UTC)
X-FDA: 84973999614.15.C882DE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 74DDD1A0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:26:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nnZWKKwQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715185;
	b=UqOfSmi6Hb41GogmyovAxeHMnlJDTB4vut5nI7LdvA/oMyrOWykBHG3pTyCval+hfLIoQS
	FsGWokZwELWulgaKMaLdBB96ykcpcdE7Wfd2Zl4BSNplOmBjMOsovhV6N7Eku1copnY2a5
	xBaFw5/mlNtw0A61yRD46sKZbl7g85g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nnZWKKwQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EoBc9Cck8QPIUuFmOHzMvwYdqHwSHiAvFbLNRDR+Z9M=;
	b=N9AFD9cIm5G6de+kMT4RcAoDUi5IBUHJZ4dTjL1xjRdI+yDf07zdsKBOUMNKPH8b9ks6oE
	Akl+XONK6tzIpFj8QXbjPjf+aQBCBJkfJT+coF8iYxz6PvMXZU4w+GI9jSUHm+QzDZDrnn
	P452FmAuGB9bknDxzs1Y3475sz5hI2w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE475412E9;
	Fri, 10 Jul 2026 20:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040C01F00A3A;
	Fri, 10 Jul 2026 20:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715184;
	bh=EoBc9Cck8QPIUuFmOHzMvwYdqHwSHiAvFbLNRDR+Z9M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nnZWKKwQGGxjXu3htGgxhTUQDnCEXUl7LPNi5xqYnZkUbGo1boxmUZ4jMcSnGPa8i
	 Cdq0zmAoabCTJPgvcH704ilNEq/Ye6VnkDCtpiBuVV+HrMul1jwsLD/FL+/NUNH+UE
	 jLwiS3icG2eXldivvwwNlYAmJcrYPX50bkfd64kAjxsdct+YancsphH8qpXVExYDlT
	 yAQhZn70hX03zCCJonjRxCouPcJSSZ+25F/wSTWv+rPVm+SfSwEsQVz28CtqYqOg2o
	 VYAg9RMa5jRoWUJRb35weSHr3hP0iurv4fyrxnkbNGnbQNMk6eGzB0KdytpIUEu7yD
	 ak+FqZs7bYOdw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:04 +0100
Subject: [PATCH v2 23/33] mm/vma: add and use vma_[add/sub]_pgoff()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-23-2a5aa403d977@kernel.org>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
 Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Ian Abbott <abbotti@mev.co.uk>, 
 H Hartley Sweeten <hsweeten@visionengravers.com>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <skolothumtho@nvidia.com>, 
 Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>, 
 Alex Williamson <alex@shazbot.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, 
 iommu@lists.linux.dev, kasan-dev@googlegroups.com, 
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3543; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ZykHi81wjQuWfRemBZVxUwwzxVVCtKrbcdoOfofMf0c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg20+71xl9Xdvl/PM42+UlvYeXrRPfeGpawtvPEwPW
 fxCOqHWsKOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATkTdk+GfVJxzqWh+YI/SB
 sZp3xrekzOOXTvowLn6rtXh75oOdWiIM/9TdVa+lRLyvavvEU3RRcqO+06X/DwT2fLhxZqHUw1l
 fjVkB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 74DDD1A0005
X-Rspam-User: 
X-Stat-Signature: fdrcepiz7b866cm1ghg6ff96ur49dnug
X-Rspamd-Server: rspam03
X-HE-Tag: 1783715185-971989
X-HE-Meta: U2FsdGVkX1/oD0DizFQFF15mQKwdGcoQWt/9SaQsk+pbENW0/OOyQIpbAGFAspVSIQQ15mfb4ukqsuH+h8/0Fe9HkbMpJFmkY/WZkp3hjtzC+EcOVHd6XEDDqrjyfqWBTWS02LoPcuyRN1sFEwbTYiAL2bpHgPPFWyz8iX620v07nfmGa7ONcS9tTAP/HGxzYBegUQyV+9hsRQJqhJkWwpifvla1L3tYbeKRLlEuszhkLBL+v292yk35P1DBzywtDvhsKhfAsg1RDjFfg/4kvD7lNmL/nnHyGHq3bZd2yG2V5qbtCrlAd4UdfEdtJPimBM67r1uy7vVF0j1/svRaBJbEaUiW7zpLryf4pwhVPoCdvUIgZT/OsZbOGZ2FnQG4fJmbB0X9f1BOGo3zCYY1Zi3JKxGE4T2ypdWpicyOK8FIfegoKui34G5NWOuLmFgAAXwr5WurazrEUYu2D9WThve6ChOY268soos+xLPZCB6ODvuMBGM3VSybKItCPivSUI1UiyzprDgf9QiF3fWxDjIN7Jk4h0/8jbU/yww3ZnTa1IaI1qqviab2SKHAOi7a8e5+NiZ/hKFDGRIU1PDP3OjvyuBtV0MbjiEC03DpbjEpy7Fng+8bS4z6sGGlJKF8DGYa23bDf9rzHMoph5vq9H+DMYx81ZWXeMvBJvpBBhHK8FZvRfqnvv+HJ45SBeqk5txyO/zvD7leUdcrUgXVGzlgqoMDYy/xYvB8bauQ7DKFs/BhB09gr7Sz5u4NqSmpYTp539SIjAEVrM+b3dnB6rpj2ENhn4SOFGhskOMPXGkQFd9XC43HNqDCwMe5diXrsmQj1YcKoej+NC8f5hApG6yKQh3kwlTsKtaeFCjbqQ2zhLQrxF1QPyNN7T7q3+JnVWHKpiCF3YapEMuKQZzSfRCrzEAtmXORqTtLnYTfOMk3abJlDkJYwyM8SHTgSZZafIud/AkTCi88AUrqk12
 gFWyEVw+
 uJcSxwn7qIlUn0z6B+/IC6sz26uBeOV4t6Op7NSf627BRPONnJElK1njzS5iXQr8EVYDY8Ez2qMR74AkoxRXRHy+t60jkIW1rhqRNbG5Jm4nmstVWbkPGhlJFglDcFkaGmjCcdut7Iz8o3znMKE9Q9uFc1Uy+jpaQ6v3YqEQXcgIMeszJvYVr+6hfZPEHPin40tsoBYupkKLvAFBn74mpeOaz34xdYiZk8eP5PN8fq//sYycSwImx2p92moheIuNj3vkk79Pzk2VWI75QAvJNRp76m1W4L5+U90ZITg6d9JkepiIl/642hosRaQME7QWZdAyDQdgaLoLNV8uXU+FYmrYHIcGHSCJZ1MucFD1p/H29bNZjf1pS0MCmMErOsW2gH/7FX0ljZcGqlGqk+qb5zbHK2VI1hLnn0NiDLpREo0nosz83TlPw6n9cN70MdIC5400SwlMJIzzs7WeeNvQN7dp2wbcs1HGUD1M9qjjlmOAEo9JwDvaAu3V8lLZ5UYGV4iH1zA9/WOw3Z+ZIHilxiy6JUXeQql1r4j/oSn5+y0auGmuZLoEpH4ly5JUioyLbEEOqYubuDVFx1y4b+IgR08fd+RPAF/m9yRXqHd1RiEE/LH6gZ0p+PUvinZ30qGg9j/eAZODe5giSVOvJ9U2qs+yWHgcEZS+dc1R41gT1mV30CCU/XPL8BhVUzlt3RB9EcaRSBKQLUVSVK7q/dNyTg9l4Qasq8+ys/2gQWHJUYumBI3PJpcuXTG14u4+6QhSK/MIpWYKz9YbocIB4k1v6/XRCTIR81C/rL6lDDGtzhArpwxwITVifbp9k/DxqknOs3mqjI5d2+xoxBBowUUynKZvO7tmD8o3ZysuHjw0V9EIP2LEv7KumQ91cYdvdpuR7kmwM/IaFibwuS9/FzjrudVXQ/WD+HFSy3z0F4Nv+a8k1w7eCL9SxcnxE5phWCRh0SssiHEmEoLRhfMs3gmRsAhUftsr1
 t/VdSaEN
 kI5W4DH+s7piMslC/l1yQEPKBFJ/wYfP2PCMiB9908e17MAq8+u/8nkck5R4QS3Iu0+5VWII+XXuiHU6XiwmM+wxjoBkW6hx8Ln9ppOi+CvM1MpNC9kRuAMC2kjxofaLv5G9fm3CMknksQ4oh9hnxLcieEeGIC0UTEHdfl+gJErFgttTBmJMNYhZHSenFMgavgyEyoiAIlLPuefRXmQYTYCO2tXxZgi52lcOdO2LUnzNUUT9GH0y+ensx6wQA1DcgiETYFowCKz6XtnGrY0YDqh3mcc+Lu7GugNNDNmP+mAn8RVDrtTGk1l6ZLywVpA6ZJotRhyZy3UsDFAxobIKipd8Ssz8jo4LqHZtRX72qT4cI9ENqv2BpEKwSZPxuMVhx2/BAhvNRT991fDoA9uhOy44+LZT0D0l6Ob4qhYAllxfCRXtX2IndeUPfiICcbJ1RIrwF7PCwYO57PUtSryE4jyK+evIRjIC2uXniydCIb5f9pm+yPZBLOtNHQl+tzA6NyglorxVBTBCJLwkr5Kqkzu2+UIcTBiS5TpZdfehEl0+aj0c9RrNDXvu9HOIfEpBZm5Euht60ElD8VMtwDevehGPe1GmQimuWoIaeIlriRMOnDy6le6Q8qxfIKReZR4gL3wLarNuDH++fsAMLZWyqKBHNmt6ejtuohPMtCXR/PpmYUnde7I/BEH4ubVBxsViQkLyvMTG+jSQAj8uQVf7kIqoaJJiiCrU57rEJQQwEoMiwFTaMeHp4HmkigWJtYKYjKdk6jVieZIGx7+APM41aPiBszyxiVoGwt5sL1NZqCPJN8l6XXUjCgEZjUGejUMhK+FFN2AE2bkR2sLT8U5sF6eyJFX7GX3M1BVjCL3qJKcR42WaK/1z/MGf51wioTAPhKfBGEnfOxw7tvazRQle1EUPe6m0eQNYOSOVGbIrZVoyh2SisvBanVTAtz2b18LDAvlt15a7BEVObFNFyO+ousP6uYksl
 fSwam4gw
 9AE94W8UbDnkunElPyovzT38//Fyk9rS/0F7Tk8Cayrm6XzlyNwoJTkqDM644xZngcQNRJ+JTskbo7f+JosBP0Kgj6RaImaFIU48cxkXi7VlHD8j35hEQWqticiI59jORqSK0xY8AGmHmmVUBnF/U2OJSfpBGL3DS4ewxtrNS73hZ9f8UtRw8K7K4TkPKzl4NlZdK5X0jE7diJqpXQHBagYhA786ogE6f1QN38ldiPYfDErn6xmEb5PkOJ1SzTPDkSaG6KfKTzQhmhjZlK0IcTCBqPEflJQfLc7osZ4Zto4FziVS+IWBf5ye9BvgTv7obgLkbSciT6ZbIo5JzwCgD4n5WENJ0M/Pa+LxtTAR7kABUX7sLYPUgnxDr5lW9x61ApkSJMtdMN2XaY/j4bfoby7+mYPJPjTFtA6ow8j8nus7dTV/zE8iT8Zrs+/Q1MXIx3Skmrya+bQxZ+QHbkjQJ3fORjJqbDCE9fDk+3qlKUqrZyAvguviM69dWNh+ghvN/0LZ85PRuI4H2zq93AC4dM4k8h2errQQl+/suuzX4tejwvCPyNPUyuVWx75hx70ui7aAksSr2w4cA13RP+W3jTxC7f8kGTVhMdyoL1VINl6k7KJp0J3J+5FbhHLTH18JTUSmIjPyqSOJ4FzWXGreCI7VG8fftpzEdC4lTZiVkfge/IWUKpEO5G4CDUrdSt7TC8ci1MJNmHOYnK8etjAcWhx6L5yrzfMPGNtTNhnlyOBJmJ0TXjcEVB4YyOvfICRrHdaRHP9AUpcMWIXenkyxoezuVw+U9KJ1Lzj34Zgj4DEouG0gkVVl4fFvu9SAORaT5vttrUAWspPaGjHgRQ5qqwRaHcCsm8r1GNRY8wtFJL23XkHEgmuCzqyiLnSSMsa4Aa5+3uehyIlOidH5pZ0cKNa2ESlZIf5IjHB3NMtcsKCxO+l3We2OolwBFSwduEMyJfWuzJhxuVmN0I/XQL1z2rRG111Qz
 Lx5F5BTi
 /BqTjT7C6jyeFTbf3NjpmLX2plzEowOVU0CMUV3uBeWdbUgo1ARXaxsnbVqtTY79pesE7gkTU0xiF7L9OEdjoH2uOnZwCI/QwLjpYZCtE7YsrvMPz1BcPuZYbdkiEWSrdVR1AoL5xmZl4GTtx1H1CfO1RdYuCF7n0ezaZY55luuHAfNA/QLOOGrcyFqyJOFiFT0+2TQelNZTNtd0VvJnKT6bAxCYPxf0y8xzTNUcDHPwkLofnE0FB7ZzaTSUkXtz7cFaWaq/I7eG5t8Ujtr4/17l3SFYKrXxhKA64oNAGsAaCr4ZlnDUBl6bL+W2jZE2Yk6Q4ra880gD8IylVGP8OMZ1o+vXq7wb8qZWhJr6rJn+IgtMP09xV1xNrH7paU/Tm5msheU9cdDryRs8wFUik4bPzpjhHuB1iVUhehCVfuazWr04uqdSWzxQrMsM7YE+SUOsxoId9+OTjjaotKSnI1ikaD0v+VHONRB6Yhd1onKGhwxVT4riMG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add helpers for adding or subtracting to a VMA's page offset, exposed
internally for VMA users within mm in mm/vma.h.

This is to lay the foundations for tracking anonymous page offset for
MAP_PRIVATE file-backed mappings, where adding and subtracting from this
value must be reflected in both the file and anonymous offsets.

These are used on VMA split and downward stack expansion.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/nommu.c |  6 ++++--
 mm/vma.c   |  6 +++---
 mm/vma.h   | 12 ++++++++++++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index c0a0869cd0d6..2a0136f6081d 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -41,6 +41,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include "internal.h"
+#include "vma.h"
 
 unsigned long highest_memmap_pfn;
 int heap_stack_gap = 0;
@@ -1361,7 +1362,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		region->vm_top = region->vm_end = new->vm_end = addr;
 	} else {
 		region->vm_start = new->vm_start = addr;
-		region->vm_pgoff = new->vm_pgoff += npages;
+		vma_add_pgoff(new, npages);
+		region->vm_pgoff = vma_start_pgoff(new);
 	}
 
 	vma_iter_config(vmi, new->vm_start, new->vm_end);
@@ -1378,7 +1380,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	delete_nommu_region(vma->vm_region);
 	if (new_below) {
 		vma->vm_region->vm_start = vma->vm_start = addr;
-		vma->vm_pgoff += npages;
+		vma_add_pgoff(vma, npages);
 		vma->vm_region->vm_pgoff = vma_start_pgoff(vma);
 	} else {
 		vma->vm_region->vm_end = vma->vm_end = addr;
diff --git a/mm/vma.c b/mm/vma.c
index 7aa0149f076c..bdd99ba56b4d 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -517,7 +517,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		new->vm_end = addr;
 	} else {
 		new->vm_start = addr;
-		new->vm_pgoff += linear_page_delta(vma, addr);
+		vma_add_pgoff(new, linear_page_delta(vma, addr));
 	}
 
 	err = -ENOMEM;
@@ -556,7 +556,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	if (new_below) {
 		vma->vm_start = addr;
-		vma->vm_pgoff += (addr - new->vm_start) >> PAGE_SHIFT;
+		vma_add_pgoff(vma, (addr - new->vm_start) >> PAGE_SHIFT);
 	} else {
 		vma->vm_end = addr;
 	}
@@ -3305,7 +3305,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_rmap_tree_pre_update_vma(vma);
 				vma->vm_start = address;
-				vma->vm_pgoff -= grow;
+				vma_sub_pgoff(vma, grow);
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
 				anon_rmap_tree_post_update_vma(vma);
diff --git a/mm/vma.h b/mm/vma.h
index 2342516ce00e..47fe35e5307e 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -247,6 +247,18 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
 }
 
+static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
+{
+	vma_assert_can_modify(vma);
+	vma->vm_pgoff += delta;
+}
+
+static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
+{
+	vma_assert_can_modify(vma);
+	vma->vm_pgoff -= delta;
+}
+
 #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
 	struct vma_merge_struct name = {				\
 		.mm = mm_,						\

-- 
2.55.0


