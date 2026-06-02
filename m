Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1729CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 09:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA376B03CE; Tue,  2 Jun 2026 05:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274106B03D6; Tue,  2 Jun 2026 05:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1897B6B03DA; Tue,  2 Jun 2026 05:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 046396B03CE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:19:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABED81C0EF4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:19:25 +0000 (UTC)
X-FDA: 84834424290.28.384B699
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf17.hostedemail.com (Postfix) with ESMTP id E580D4000C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:19:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=peVpd5Nu;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780391964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svkiNZw21V/XkupJT5UQSR+7TebFnLxf7g5NPNd+ovg=;
	b=nYWtuNkRos1gNm8IWJQ6pAzjb0ZN3HganY3EjSMhVIsHkfU1SO35OeSMAsBZ/gH0g4C5je
	G74/MLPeaWX/OuT/VIJ/Mk0vt8J6CS24GZ0Lo/crAdjD2bD7ME2mFx7RigVDob5dvnOfBp
	b5mhLxtUYcKuzsmwqrQ2Pzw1d3xif9s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=peVpd5Nu;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780391964;
	b=CCOe9Qg+yJHAvziyeBjzAoFFKJ+DuemPr9ZVe9cO3bq3hrOfDqk9C29kejArPp5hTN53rw
	VQ9iawZOIsQ3M07A8s/yOxzFjjAyV+tS+2J//QyGsFPxNnH1V9b0a5BhDXYRDJVGid7kcD
	a/LqhTl/m1LUeT7Q2gbeTZOhhlzCBIs=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 47C38D1023;
	Tue, 02 Jun 2026 09:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780391962;
	bh=svkiNZw21V/XkupJT5UQSR+7TebFnLxf7g5NPNd+ovg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=peVpd5NuXYYLA83lZsm/uc3I0zHN2mTApc6949ntTPmVV/LUV9I0QsQSWHGdOvNAf
	 1DuqIr8tvUg05qxlZcVBcmLCs9bf8fk5KUKi1Ih8qvZdWEjgStYIgpgm9S0hXNoko8
	 niVoTza68JiwYG5KvYGbJSGMy2ZXpOQxdxCOuZ6A=
Date: Tue, 2 Jun 2026 09:19:18 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 3/4] cleanup: Annotate guard constructors with nonnull
Message-ID: <ah6gFnFkD418B56Q@shell.ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
 <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
 <CANiq72=vaiGXPwmdOuTHDp30Nm62UgjtL1STJx6aj=dDPWTQYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72=vaiGXPwmdOuTHDp30Nm62UgjtL1STJx6aj=dDPWTQYA@mail.gmail.com>
X-Rspamd-Queue-Id: E580D4000C
X-Rspam-User: 
X-Stat-Signature: p8mbdwxgb186aftwwz4jd3muawmdq8ip
X-Rspamd-Server: rspam09
X-HE-Tag: 1780391963-970934
X-HE-Meta: U2FsdGVkX19pi9bR5wpNYXwIFyiHSKBP/uSNf4prWpX9r8efk7E/7knG8qbkSAW/vKDzEs9PQxeVZObhZS/pJkMJaslSN9K8kcg0vDh/t7zSIuF3mnHnaPpdB7pNTaRDFTZqB/8LuGL8sujytOWtbdaGfcgJR+in/xwckgA30KWoNjZBrM+5j/VN9zH6XkHbuc0g3hwdw4tKguXw1sTu5fQ9xjgls9yRRjfMyBXIstQOVuceG0p9kC9aOIYyQhYuyq022rZz+fY2BHm42KrGg+HLS/fD1Ohg2D138Wsn6u8xPgFwSC0kJ1deNLO29KIuYOZVTQA1I/80IicdhGHBQbK+HVZYV3v9ktbKKqJ4gYRrUkcMJTnXawvJ57DTdXyAu1D1Oay+e0uqi6s40A8g/dyqpRGaK8/nm/JKHNGGlVJM5lavSR6FJMWLLcXK9wwq5Vo4lq/DLWYaF/Cjf2JEY7zCWMBcRZ6HZjAEX94xh67uVQVv2Da5VvZGmfyApjfdysBScn/ybeiiKfoWw6igNTH91/7UoyhUDJ4W/ISYUxXEG4XYFkIuuUH9w4ruNJzGJ2+Lqh3+lIk04la08B2HI00uWE7dY2WNY8kV3VWAlm23h/hGAgwvmy8o7dLGEBvHmYrawUjowXQBVwYDhelO0ibA3CS5uFvOi/6kifXPIx5sIrME0+RPNf18He9ywXOCmXQh+O8s95eEoWyUABay+PRHFVbGybrJLJTo1LmUqurSX9rg51y2hvMXdgZ6SWLZ3+/x9rHJ/lKUaYWLaHmo8hB+Mv+jLIbFQvZ6RCNwG0i4TFePJ7cAGccQBGO9SRffOJZFolYJjnxtmbhJ1SJXvYfKZYMWik+zNQ70b6mlBW76qG6frzBRu11Rsp16Vtu/m1dgUNjuO3NaFpUn1bMIvQwgcKNamZhAvbGLxr0frpl6tAnnPTdvEhYmCGTzh/ncnhRq35O4KfBp2FGy2V2
 1N5wr6nG
 Oq7Is4b6mp7npwFMrjodBHqUHroPwBQ3RSGYBtmaQyrmS/Ih9P3MG0079ABDEJXbLXYeYlit30e56zYwbkYqZgsGPuLNBiYnaUGjHJwBNjyiVe/W/rH9oDY3okzQkCh/qGgauNaqE8DL4znRFV5w8XAwXZIpCPuI/UWMiOfox01cKUd3hdk3rNS1g3wXIwfrm5pEipL2Yr9JF21EYcYKY7EXeIiBnifEGRQi1ZfqzZiue9H8rL50G48Sfrq/nHuef9KvPV3TubIAPE1/yeeXDQJo4bIewqpI5p9CmP2EIo7AzUyyxGgGVQNM+6kY+iAtSo0rpzLDrnmCuhyk533GstpaRAEQ7IExybrciiuxKMw33b0K93d65ugvZIPbTg5lsh93cwqM3okLZFBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 09:32:12AM +0200, Miguel Ojeda wrote:
> On Tue, Jun 2, 2026 at 9:13 AM Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> >
> > Miguel, I dropped your Acked-by due to the rename. Went with
> > __nonnull_args() (over __knonnull()). Happy to restore your tag if that
> > spelling works for you.
> 
> I am fine with either, but thanks for the caution! :)

Thanks for confirmation, Miguel.

> 
> I assume `_args()` is meant as "the `nonnull` for the arguments, not
> the return"?

Yes, that is exactly what I had in mind.

