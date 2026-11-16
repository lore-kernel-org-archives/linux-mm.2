Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E374E606A321
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 04:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZNtryHMX
Received: by kanga.kvack.org (Postfix)
	id AD7876B05B1; Sun, 15 Nov 2026 23:14:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88606B05B2; Sun, 15 Nov 2026 23:14:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D5E6B05B3; Sun, 15 Nov 2026 23:14:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 689176B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:14:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 912B0120596
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:13:59 +0000 (UTC)
X-FDA: 85439664198.20.969D282
Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	by imf16.hostedemail.com (Postfix) with ESMTP id 76B2B180002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:13:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZNtryHMX;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794802438;
	b=4SzN+5ltFhpVZL7/VAP1cjcwTzgicLKMlPXL5TmXOHsxf1e1O4S4BtV2OSE6y9wbI2g+P6
	J/4Onv77SiQJfxjIDA3d7BNWxxqtn+v+WfcaJ7GHaRGsuu3oFuBH7vP0NCZyjYUzbaQZqx
	B/Kz2xtfXPdEHq3arTqelHctLlemeHE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZNtryHMX;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794802438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHvuJtluF3E17fuD17Qr8YtY6RUeccc6EGa69X2cBYQ=;
	b=hXpYNzbcGJS3s9lrcwH2Q653xOEX5Wezbp1dfOscGJZO04p70n/0s+mSHd503TXTv7y0C1
	RU00puVmCe+Mb1LkA4Whz3bu66S511L0AQAur3TPQoVtCNjPAnBAFbrppkZyCGeqK7sqz6
	UI/mDVaGsBLeTdDO8IQ9ht7f8P4Nh3I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UeR2OVY7Ll0L67nI5WQ8q8etyrOik3DMQLuEe3vfhjU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794802435; v=1; x=1795407235;
 b=ZNtryHMXk2646niLSKQLkzDyvLxIcw/w5qBDbvmZxvsBpQAhb/6/66FKmcGmbzGGLl3NnPD4
 LYryBZcguBNcIEkJiA2BSxfK2AtMYpXCksMLs5vUK5EVnIGOHe9G9Q+HvSLlHjRsowkscnkdO1B
 0me0s/O9q2PczDxQ9sZCxzyQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 43362223296a28e1;
	Mon, 16 Nov 2026 04:13:55 +0000
X-Mizu-Trace-ID: 43362223296a28e1
X-Migadu-Flow: FLOW_OUT
Date: Sun, 15 Nov 2026 20:13:50 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yingjie Wang <x-professor@outlook.com>, 
	Manfred Spraul <manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Vasily Averin <vasily.averin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Michal Hocko <mhocko@suse.com>, Alejandro Colomar <alx@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v5 0/3] ipc/sem: account dynamic sops arrays and validate
 SEMOPM
Message-ID: <avqC4DnjkMZHjRrq@linux.dev>
References: <cover.1793250194.git.x-professor@outlook.com>
 <20261115141206.920bdc8c5a84073712bb5c3b@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115141206.920bdc8c5a84073712bb5c3b@linux-foundation.org>
X-Stat-Signature: c1uedr4joztz3i6oxdyqrgzu4yss9dwx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 76B2B180002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794802437-955945
X-HE-Meta: U2FsdGVkX1+XabA4kNmURNyYztXm2hqU09hI9mQaHe4xxc6kUE13qBkQlisztsDEMsJ3ZA/gtMZi7GWRrwjzY4xG27mfb1+X6WFWiFY0EdOdUKbRLYyBBPFEw6vdQPWxwoRydQIMbhapebFVLghb+8xcbGLNitG7BPI8Sgnm1c7Mht/lyog0QCItmv+hvW059n53+eVDVxQ9oLdbGK/2QlQvv71Z+hZZHOe0hIilKMH8QfeG9A75IFKZaCAZU3wPEC3ix3xu6rFxcXsDmX/sbDPSjdpD9AL1m7pjGlQ8dsLgQH3SvnofaWdjn3S93OIsqtkNw3s1ouAEl1XJviF7psO4WX7WzEo5Wcj8oDdphi5VEk9i7evsSEOaTt0Q0PBTZWm1E6LAamqYvR/HG9xL7GLcgxxiTvJV6KKXnabm6w2iQb8Yf77R0tPFWBe/WlWa86gDX3bAhGbiameZVYeoJ05uAJlZVOMtHYMrWg8DFlFIWl6C9GWSo0pzAceqrjz9vPFloYq2qotYqKOB4h3VhdkjPUjuHGDoTOT2GX1q4wGkCIaKzpIv4cCuoC1sMlEXX+XQOfak6jcJ7rs4Fc8v/QfHeD2+aVEHDKKxErxld2nskFJ7/L0K1DE5sS0wq3PLUxT1lySa4hvTgLo5rntWzbPyy0QIBybaMByXkDGICk58VUcRGz/uVQ5dnnSlY48xjs3whMKcYSnoV8s9C+J5B3xUOZ//PzWWRP4Wowv92bWQb9/upt9Tzr+mHEJnCovFXBWXaCxhltlaD1qStotB6SkEWSDtMyfPbE7Umy/nxm/HHB+SvblCtOtE5S6SHjo/IdPoh9VArQOvT+PUiZjt86ZrL+YCOiTBeJ0W+TO6On2xat4BFbSmdH1uzKzDqIId88bkXz2Cj9dXvyOd43zthIxkq8n0o8HCQI1bHwfhF6Xx9QMq1cuJZ4A94p3Bh+v7r4MlSSLCHKjdVWQ2H8z
 KFYF6P7e
 FlYwCeMrBYAyBnYKh0uE6Gw4v8tvoqIbT2WD7ceMsodQnSYMpLZecYD7Tu+pHNcHgZcu4htd0hGaibzisu2ASoDSWydnU6lztB6MgZLeE+2RITPZJRsouRo5Iqg8VdtnOLLYDIejfXi4SyV2mCXPISg2/W65Ikmni9rqCLNziG4C3D2Mh/7HjPKDRM0fUWwPTS9yFazuh+TK8+Wp4aKe/EjQX/qVvdL8ognRukH1neTg18ne1cE3WVDb4hfPM9Me9OYydaE58o7VsPPKN5rqJUCIEm2TmWTogx0N/MzrwN2q0W5jvfk5xf1MPiZRygNFQhDWgdNwg8pu9f61X1YJ2Qqz76w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 02:12:06PM -0800, Andrew Morton wrote:
> On Thu, 29 Oct 2026 05:03:24 +0000 Yingjie Wang <x-professor@outlook.com> wrote:
> 
> > Shakeel, thanks for the suggestion.
> 
> Thanks.  Shakeel, please review [1/3]?
> 

This fell through the cracks. I will take a look at the series soon.


