Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 765EE1088E65
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 02:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478D86B03B3; Wed, 18 Mar 2026 22:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429506B03B4; Wed, 18 Mar 2026 22:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3186B6B03B5; Wed, 18 Mar 2026 22:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE266B03B3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:55:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B83CA58342
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:55:42 +0000 (UTC)
X-FDA: 84561297324.24.B4B7BA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0269CC0004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:55:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qaXE2ant;
	spf=pass (imf28.hostedemail.com: domain of andersson@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=andersson@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773888941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gRQiCxpdXjuk5nPBj4oIWLUzu68lg6KE4p0rWyHPtAI=;
	b=8j3oPksIYUxgV0SytlgavZE4cRd4zAeY6ZIfG2kRTXsbEua0hbP8SkK73fslXkYjmzyBLX
	hiJhGTqLGjUQd29UCm4dPy8u5eMDjtuuHvEIKwqwESoy7ZTWv4w1vn+U3A4xMTovdFOJIv
	7xNX8nIvDtsang+0qaDJ7e7Y3mMNrCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773888941; a=rsa-sha256;
	cv=none;
	b=tzYxYlDPowLlenSCegVYcLEQdllc7ywuXDt2ofF0MCJQvfb7uR79iFfyEkMLtcKp+8GTv+
	hU95rgguXGZ/A7R4bL25EihlxLHOz1hlM4kErYRMgbqdokL/TmCkAJ2dfN+Bp6OERwBHxg
	EYsay1sXUQWUVYC7kGrNFirurs2cWFU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qaXE2ant;
	spf=pass (imf28.hostedemail.com: domain of andersson@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=andersson@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD7DD4393F;
	Thu, 19 Mar 2026 02:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4591C19421;
	Thu, 19 Mar 2026 02:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773888939;
	bh=JBDcZtrG6mP/xc3gO7VDWwX/f7UpvWRqfTVDJQ9Ka3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qaXE2antR+2qcW2JyGyf3j3ytXGJhuhWliLmRXEZCYYn3f6Iz2vAzBbUw06nBEBFM
	 TBSU4N0wO113tYoYLjp0HbJcD6+WDo8wE9KF+IF0K/FJxW9NQ+pv+vt9fpw0kYjLtI
	 i/FfWVfuTuR8AQPYvbskeEq0gl92MOu8sruKbLBWqljXAWmLQvxKglVXDKO9dwy1Kh
	 HW+fxYftX1Ge9fxykbUsL8fcIew9w1yQg32FFezUgESpVLQhu0GB8UIOXQ2LXp7/Lu
	 10ralfWqjLT2qK79xcQWf3ckQP4IyjTB58kbURxZuvrG2Wwu/Kz1KuxHz27iBYUr4j
	 ynjBwMPt4lsgA==
Date: Wed, 18 Mar 2026 21:55:29 -0500
From: Bjorn Andersson <andersson@kernel.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Eugen Hristev <eugen.hristev@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Petr Mladek <pmladek@suse.com>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Saravana Kannan <saravanak@kernel.org>, workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 00/25] Introduce meminspect
Message-ID: <abtlUQqMOxj5PwGB@baldur>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <abdnp90cC5PI9wyz@baldur>
 <20260316181647.m7x4ncmwdjho6yvr@hu-mojha-hyd.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260316181647.m7x4ncmwdjho6yvr@hu-mojha-hyd.qualcomm.com>
X-Rspam-User: 
X-Stat-Signature: 64rgf39azwyew6bn9f7zzin45aie6mf7
X-Rspamd-Queue-Id: 0269CC0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773888940-257747
X-HE-Meta: U2FsdGVkX1/mkXVIlHs4W9UKS40kxnUerurfZ/Nr6wGBMfPrGXaZjpwp5AapTGgqU+senudfEEfonIBhuqHR1a+kE8WhCvXGoBnmQsPCJ5sj/nhYaKAZaH4EnqvbipQFNCiYKNMRhumab1+eCJEnJNwNrmyTr+IsCbXtAkK/qOlA76xJCYfZZepDfQcJSyFDnRjHvvSvhD5PUPo872KAAHnIj3j5oEh680xCI/laBBXLVd62V2ZZwFUbRMHzdjnneV67uxh/BdX7OB3V1xIqmPdReFPWClBozE1b8TTPE41bv5rcVlKX9DY4WmUO83kOSqQY6zZYDzeDe6ETT4gMaGIO9OBCinHByoEZeDLySJRFWpKUg8WTw8Ova//BiHyNenvwBDDvqdZ4Azuw1SEA0SwL6VcdrGoUUg/4Lp7M8t6F4pglUQYqkGDT8JoUqHUKIl3hhDbbeu0yjvZOIsOfst4qK7J8X3xJPVfMVnPRcRB0AscxExZgenuYRU7ZTUfwldFaQSVIlHkfje+s0gsSvxv6RQAvR3YQW8zf8yBADDL0m9m3m6445iQ5U+9YuqommOQzCcBtgih187elUOOUHVssNtOn3PIvHwQSEEE+/FAXWKYAhH0xooPmlpT9CG+UvLR3BqyyocUj31VuXilfkOdGY9/mG0OHRyxUcnTexOXuxfgTAV8YT+6W6HHMVKPthRfPLCfoaQuc+ue+a9pC/Mo6VcwOA1pBxEe5FUsUr6S+7Jupafs3n7Y7nvxCFFiUaEGkTBL/NxYe0bOjmZMv6gBRcFMRbSRf3tmsiZ6jYRonbih7AXR3b1ORRSXXAf/wWXbBVWdA61fG8YSRKsPNHVG9JCVWWCdyHx7x4/v+IUL9bFCybOZd0qxUo/Wg7FZdCbgJ+M7bTR3IyvvoU7FDwmV/nYG0NrVPFNd3TKymPFA6e10YF+3ZKRY0XCxQSQUyNfZe8CUwMXbUAUoz445
 Ns+syW7m
 N06eWs3cG6JAwnvnSvfMfE6T9d5oNDgz//1DN0UfIPUmmaRY3r/HcKQ1gbM0HTctJmpZk2WMHWC8RpOV9gxlTmR/E3JurGXUb05IOQ7SDFtAxxDi+3etA9W2ad0TLqCeJxYsRmSUOAAEt33lnUDXwYRZfboIxIEIJMsqU2ejIKlTMRSClhHjpymHG3po+KUv2xFmgvHAcTC3wjS++aM1Nk5NFXQS6vmuKCAkaoutzpX9dhONWcygNTfy8uB2diPEWKLFfcRip6vFs8RYSSvc+UrZrtjSh8XXjsAuAPLuLudnSiX52VAWkJJBJEJxE7/txXHcPz9W96avNsaIvxh/pJ4W0HQCK6q5kPtI2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 11:46:47PM +0530, Mukesh Ojha wrote:
> On Sun, Mar 15, 2026 at 09:24:39PM -0500, Bjorn Andersson wrote:
> > On Wed, Mar 11, 2026 at 01:45:44AM +0530, Mukesh Ojha wrote:
[..]
> > >, to get all the regions as
> > > separate files.  The tool from the host computer will list the regions
> > > in the order they were downloaded.
> > > 
> > > Once you have all the files simply use `cat` to put them all together,
> > > in the order of the indexes.  For my kernel config and setup, here is my
> > > cat command : (you can use a script or something, I haven't done that so
> > > far):
> > 
> > So these need to be sorted in numerical order, by that number at the end
> > of the file name?
> > 
> > Do you manually punch these in? How do we make this user friendly?
> 
> Yes, manually.. but I think we can do better. We could make
> this more user‑friendly by using the section header and string table in
> the md_KELF binary both of which existed in the earlier implementation.
> Then, we can write an upstream‑friendly script that reads this KELF
> metadata file, checks whether a binary with the registered name is
> present, and stitches everything together to form a complete ELF that
> the crash tool can consume.  Let me know if you have any suggestion..
> 

Can we somehow identify that these regions belong to the minidump and
teach QDL to build the ELF for us?

Regards,
Bjorn

