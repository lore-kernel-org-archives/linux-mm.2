Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 630D7CCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 02:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9EF8E00E0; Mon,  3 Nov 2025 21:52:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591778E00DC; Mon,  3 Nov 2025 21:52:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE2F8E00E0; Mon,  3 Nov 2025 21:52:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2A18E00DC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:52:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB381886F1
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:52:30 +0000 (UTC)
X-FDA: 84071401260.17.128E603
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 391FBA000D
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:52:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q7xTFejP;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762224749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BFBWkf/8rEOWM836Ntv1gFfhVHav8x4T+hrRvRU0IU=;
	b=nQxtuGjNMPGv/yL7CB8Pbnxg+NdUyqE3EsTtITHKf6o0y41O8ZBswnDd2/ODYxm58qnjan
	5CMANv1Yp7bTfhrsy3Ms3jkz+kI1AvT6/cT3M3lApahPWvVmsm6GM81wWqTBkiPDncFcwG
	//HAsCav9s/WdOrdyO1rNkjKLk1LNHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762224749; a=rsa-sha256;
	cv=none;
	b=nLl62DucHuNkgBH7g30w35RiuTzGNiAfXrU9Ucdar7PQAREl0qGPwrcOD/FKjPfJr+4vEE
	460hOoy3vVdioTX31n856584jLOYEMlYlYx1W/q93LjQYReSXvEVsNoT+y5DgICngi3bJm
	zcp6vgilb2xJSHf49JoHFbkZAqAuMlQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q7xTFejP;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 200B3436DD;
	Tue,  4 Nov 2025 02:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA1DC4CEFD;
	Tue,  4 Nov 2025 02:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762224748;
	bh=Xovpelytaf1rVw6/MGWZziRvb+wid13hMajWjKa65Y8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q7xTFejPKd6NhT06RWpXtSixWQbEpsjjKBezm1wVg44aGl0ALe0Oy1XhGDJVqSHHy
	 MAJJ0qgiFXuHTQuaQRCrTT7oBrEjP3r5aNq6iZqPuLddO7lzY8BxtsRizHiiSc4pKe
	 hIbRUTmPyMmu1L6vvb9GyRzw3s52raw3T8RmJaig=
Date: Mon, 3 Nov 2025 18:52:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>,
 Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>, "nao.horiguchi@gmail.com"
 <nao.horiguchi@gmail.com>, "david@redhat.com" <david@redhat.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
 <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "tony.luck@intel.com" <tony.luck@intel.com>,
 "bp@alien8.de" <bp@alien8.de>, "rafael@kernel.org" <rafael@kernel.org>,
 "guohanjun@huawei.com" <guohanjun@huawei.com>, "mchehab@kernel.org"
 <mchehab@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>, "alex@shazbot.org"
 <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
 <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi
 Wang <zhiw@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju
 <kjaju@nvidia.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "Smita.KoralahalliChannabasappa@amd.com"
 <Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
 <u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
 <peterz@infradead.org>, "linux-acpi@vger.kernel.org"
 <linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Message-Id: <20251103185226.fea151c58ce7077b11b106aa@linux-foundation.org>
In-Reply-To: <aQjy0ZsVq7vhxtr7@tiehlicka>
References: <20251026141919.2261-1-ankita@nvidia.com>
	<20251026141919.2261-3-ankita@nvidia.com>
	<20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
	<MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
	<aQRy4rafpvo-W-j6@tiehlicka>
	<SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>
	<aQjy0ZsVq7vhxtr7@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ptdkdkesgbs8ozjj34t58sbsbk3dykof
X-Rspam-User: 
X-Rspamd-Queue-Id: 391FBA000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1762224749-961693
X-HE-Meta: U2FsdGVkX1+KPC1269NdTyDuuonRZnPdn/tqGFiZWbtwo3e2FtVRJsD+4eZBpBYJH9OcBoPqh4Ap0yRnCM2YJL0LV/l5L6CZTvfOOMacYxZt/GWvxvkeNkGDEvpIgE9eNUzKY/mhzmiU3qP/rjXC+MGnFYIRuVjV8kml0KuAPNb5YGdzma6DOAhNer07iLLstnFagv690+mdhEseHPWH+5YqwWXgmtzc8NuHheoytJz9b48QK9s0P4WqLTLG3R4V5fdPerfCk+qCnUx6EKGFgj1V3a52ZokoKj+BF6l0DPocpatLEYLw22P+Lje6KKsdFqMri+OcT5U7BRuB2wKpGcEqSg/ppFIWjNEGsAT1FoORXFL86MJPUO+sGL+FMsYJVmN2uW0yDeBEoozgPcfn8RJn9x/VZUbECwjuCsAC7GaXM8qm17oIjtYmZiJswxNT9bRLTUU0b0n6HdaGWR7Rvv/pASnYX40R5xjjYLFe0zKr2FO9bCpEL8QD46KTMuTJSPggaiGacP/YfwwzGgehHvT0DASu1RjLz4qlSAXyA18vDtC2/OlA+Vzu/j4M10CgwAM4O8zQkBlBqdm39r++rFIIIhMpQhThY07/KgwMLEVHf/m+Ba2CsD4PNS6bu45TkzJCijQLvOFdzQ2qoE8fB6vVtXnUF86BR1TUscvqPgmZdvoYEUlaZ23BG85j9yvsxSm09dFkzC0Ghaw90kimqLZbKoG8eB1id3zPbCCubO1+V7zjGGsFu00E6DPBDPRZZx60+Zskgn6K1/v3tL1HFYVnScrhYo+niZtJHcUmBANRvJBm9vQQidrRpqcP6K6eP4Nf0vCU4n2howPZ5RzmOZzhKCP1GDWk6wwrvxDg0Hji1gitARtD3FChKU6rQTup32C5dvbB9N2Y7qw1ITbHpVvc8W/tJBbO+jH0cCXCQUmw1BpPOTAAfsgx6udL92kiyZZdr0hJgdO4q43j+pG
 FxI9Lbqv
 Q5mvZa2rv62FoaKvqX2GMOIb1vbwalBftCje8kUr0dRv7BHuhbXPiho3h7ICltL+18+cCN+1Y2KtO0NNOEpD7lePtszaQyVYBoB4ZAaGg0IQLLe6BlURtl13ijVURBtuh5MichaQjr28+lGpob3y+5RT/OXruN2yyv5Pjn/q4BsH6hrBJeWIUWOz4IT9qyRMy5VT+TmKj8IDGSQExgMibAhGcQWuOiveB6XpenWoRt7HLavqtHux7HKfXnRM8kpmTld8Ox3hDc0L9iY0k7sXvHmm09+dnPCal10EVq273aGHBTIfK4Ti9pw/EMX0kJAFzEqHGr335XkjvQbxOyE0LmHsn3wCDLW1SeIb2cfVxVpZljKkFIHXyNikBuGdGL+0PZOLKecwo1oneDayDFuhZ94kDKGaNqbY36QLq3R7hxMu+OzS572cip7bBlacSVoX1ndDmxtxpkUiWTEOMThSMtCGyAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 3 Nov 2025 19:22:09 +0100 Michal Hocko <mhocko@suse.com> wrote:

> > Hi Michal, I am trying to replicate what is being done today for non-PFNMAP
> > memory failure in __add_to_kill
> > (https://github.com/torvalds/linux/blob/master/mm/memory-failure.c#L376).
> > For this series, I am inclined to keep it uniform.
> 
> Unless there is a very good reason for this code then I would rather not
> rely on an atomic allocation. This just makes the behavior hard to
> predict

I don't think this was addressed in the v5 series.

Yes please, anything we can do to avoid GFP_ATOMIC makes the kernel
more reliable.

