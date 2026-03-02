Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4827EEB3634
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFAF56B00A3; Mon,  2 Mar 2026 15:27:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1466B00A5; Mon,  2 Mar 2026 15:27:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9257F6B00A6; Mon,  2 Mar 2026 15:27:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63AD26B00A3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:27:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 344D61B742D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:27:28 +0000 (UTC)
X-FDA: 84502258176.21.D7B76BE
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 41CAB2000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:27:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QT5AUU3U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXVMGTylc166eOKIIuxDxOR/XS/9oedP5aBtDDDLocs=;
	b=rLQVbg0dkv2nc/vfvxpeWFLB70AER2ZiAMAYPp25ssMb7JKaYHCGgMD9/7p1SCeni8Xe4s
	eXoYSl0kiutqM3sGbHFIONxfeQVp5sSevnlpzkamWJZC8QKzUVJmsr0xeYe+XFN2GN86mz
	fCyUdokcGgxPZx0sobqKBYan416tcdc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QT5AUU3U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483246; a=rsa-sha256;
	cv=none;
	b=Vrg1i9CF11CTGWadDiRJZ9eCXwldErQX2lOo/0gjsAPaKSxP0oENf0SnR3Zg5I1FuDAauO
	cUQp3ixbLYH0rVuloPl2Pc7ABvc0IhtSvxGTtFxKPlmwn/EH2aStPZqR2GLPLgZi5tVYl/
	k5mp2AU0w1aU7wpBGToothMF+rHRzpE=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1275910b930so2918880c88.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 12:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772483245; x=1773088045; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NXVMGTylc166eOKIIuxDxOR/XS/9oedP5aBtDDDLocs=;
        b=QT5AUU3UcsTvhUVh3VJO5IQnHX+tncHJ/vXHFaDao/j6wuZTeRTkS5cnoNWQOs3VTd
         z8MLtfoNWNfKOcveU2y57d5ZqyKu1VZIIb3dJ9l9Ls2ikSa5l1h+U76D61UTj7T1MtR1
         sRA4ZUUeCZl6ZmNECqb7RZ33YnNcCrGRq/7Exjwjab/ijuSfElud+SyBtDLwlBIpj5hY
         278ESkf29MvIhc7CjmJsqb9wg2x12t7ndwnH3zBMLjC5tov6EiiAqsM0pakIN6p7oJea
         NXjrNogTKET0WFOgKmvWXnPjEKGivboO1mGIyfmM4EsK/PKY+lkMZV/gEduSe/RBUc68
         Boew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772483245; x=1773088045;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NXVMGTylc166eOKIIuxDxOR/XS/9oedP5aBtDDDLocs=;
        b=K8aVMv+36/Uyxn1Qrc70YzERM941qYIWUbXvgxXnk22Jhjlzw1F3SJRg1b1Xdl0j6k
         E81klXUO5xcnXWwZbLhDIhY0AHgmYcXyXkAdnAc/Azi1cEz0t2Wydsbdb0LdxeePj1Y5
         5sMqfxH9UykxOz3NNDiTwzwe8h09KrMj54HidRqpR+k3SylnNDIvNFX19kdCP2vkA4vY
         1hLWbfChOEpkX01AtAi+v+iX31HeT8STRx8JTXXctXymE5lir3/Ud4+eosDjqlBxAOgx
         zdZAJIvIGdRyBt9Yw8HnrA/mLNca3hOyzi79DI6zP9ELv8x7o8UxGRMZ71q+jFsYYJ7J
         H3IQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/62Us7HMrvtR1uGa3BGDpclbujRjzVz4AW2tRVt5pBioVt4nmEfXU+oeMp+R7ShH4183Z7LMz3w==@kvack.org
X-Gm-Message-State: AOJu0YxlsaLIJOuqIC8N9NKJGrbvAO39GrzWSQqJLUXVqdTuRmksPGoe
	0p+tVKBPc5L7AQFMbgDOhBFZ/JusgNmyGO4dbk4CqlC/NrewIL4SRmC1
X-Gm-Gg: ATEYQzyWcNy633Z2PIyzEAbyX50Y0HJdvL+xApZVq7jRavwLUp2+bWZTXdR5LGEC55S
	HT4cx5Nuvx9ihkgaQ8z5T5FPJM+busjWpea9Q/iBCR4V4xVy7cnW0U6II5RA7dSjtJvRHJRioo8
	rBWNrErWroB6S9gU+sP4mSxaSJU8zyd+Th0pKK1QDtfmkVOXP5x8J56avl1KPf05dmhYpS9R0IQ
	khJOA/qauA5OlI5O8xK0UVfXrtIIn3hT3Ho50oIujtHsZ1yDPr5iRKcDP2kTbyTMrtGmyYz8+0a
	QhHg79cuyykp3KScPDJRR0YTL+5owkZQhaTCyD3dRfSfblHo+7FDshXUyQNTrHsEtIexuimP2T4
	lXLehWzLsApwIEwc8xz4zfDlPgMH1foQRxhoVwuiq2eA3WimAehLcvmCkTmFAm6mEjaeoRMABns
	5Yxm/IhCt1OjFSwP6VfMTuriMwDSuvOgIY9BymRvGNr2s1UZIVYjGy2Vs1ATOpzf/LOujw+fKme
	GtW6gSoRkf0d/A=
X-Received: by 2002:a05:7022:61d:b0:124:9f56:832e with SMTP id a92af1059eb24-127890fc341mr6372453c88.18.1772483244781;
        Mon, 02 Mar 2026 12:27:24 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdfed770dfsm5982290eec.19.2026.03.02.12.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 12:27:24 -0800 (PST)
Date: Mon, 2 Mar 2026 12:27:21 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	akpm@linux-foundation.org, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6 0/4] Convert x86/mm/pat to generic page table apis
Message-ID: <aaXyqZpenNthBTq4@fedora>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
 <aaH5Z5HTC5GyJ6sT@fedora>
 <2fe139df-1764-40e5-983d-48d7f97c2e39@intel.com>
 <aaI6Vq-uyJ6F4P7u@fedora>
 <bf7d3f8b-8cd0-420b-b418-8b45bcfbcfcc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bf7d3f8b-8cd0-420b-b418-8b45bcfbcfcc@intel.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 41CAB2000B
X-Stat-Signature: xaueobr55nwqb6kp9b7ztdtetyoaswqk
X-Rspam-User: 
X-HE-Tag: 1772483246-87660
X-HE-Meta: U2FsdGVkX1/3TKYyxGyHPsrtpBdC9eZQJWpK4tf8oBGZnOT3Xq5J6CbzisGcL2lPeZ5ZdyQgCXj9KPHBR80ZuE40/DHrGFaLgDmPJXTgFe9+nXmIZnmfC2tILrK8pyLWo6BjOhZSMvnIo89r6ineXa/p4BpcK8lp5DPL0YOHpvydxszeeoSYQqGAnan48zb3NpTfeSBcbiFV/du6vi9sYuvBPlIdAzse8yUPHs9Vww9ySpmBv33KAGLJippmX8YFDeInBXnnf9OivRkpAIo0DzAS7BPkyKYKPJgpVTWhU+ah/SpncA3CX2FjDajLLSQivXBBE1LkF1W3XfgSc9/2d0LNjyEkW3lo7MO/XwAgeeat7LlX0f1C7dJFeh9d+l0DnVQA48NcMIyNU4tnSPtgCW7Q4s6ynVnmFbwVJY3P8JVdwzuG85dDSqLrHXQmgchceFHuNjn5lQ8AOvOZDkjf0cHQ9/Lj3VFd0xF8R1Ncen0+gzkVyQI13q8MraRguUHYTXKMuhVD32ovfn3aNYQI342lXYvq4WdkW3W/wKM/qXrhNYLt2X8CtM3oB9sbXrpArSoeGrYzA/FvhKlgjOI4ADV2te4NNRrIeLDts4GJN69okdiQIoJqDLBsIE5JO+CijkdQAYbFhmX7KGvBXFltAi3qusVDIbsGuKkosm7qCU8j+yNN42gygX4H8Q+rxj4Rm3E6eTQacqC179ur0nM0VXHGF0aO23wD5kuwoHtZaGnjvpSabZAsS7FFbBk5AZ1GlYAl+jrshT9v4TLEbg0NI6a+ZkgSTZ28fL8IunVN2OHx2GCuA8R4F2vMA5vCk9bKMYAbauYZ2a9IJzJEyHNbR9feKtrMPTINoG6wCX3FYgPd+obnohNMUQr0usblaQUuXqbea8L9rZ2LQEECmjLELQU2zlTA77upKPYvHjlIzKTh6ZNgvJs7GkcfFM3opPYqP7pWiWKfGODFkHOVzg/
 o44POuST
 uNgoL+qLHMAxbhs6B0KEQCtMdWNpdEa8Y0wfN6nNDSAXEuwgb83MT8PeHw/P+QlCAYfW3OWHmxfbCVZB40+NluNHHy2ooeHENGXHCsztuPpen4eb3IUvpUjIllur00U2mJ1Hq6HGzGA01tAVB4TCBGR6ORunqFG/i1rC1FfT4yDzQA6YI/+23Q9B3aKYjj92sVn2ImEv/Ga4pCW2Cmm556J7leoji9UDE2i7Q6783sb108o6Bk2Z4XKyNAIAKXdwaKRxBKq03RkJfNd68eYUZ3YIxntJ+Gh6PIMten30sVUPsNAjhxkxjTInvcvO077bTE6k/25VXWmVW0Kch9Hsz8+0jqFUQPA8pnWdPRmPqSPh1C+piMSIIZanXgbkSSqm0eBjLHQ9n9dEnAuI+26wTADMb2wFcZjnkTA9iOvC/DtvfMClPiEV65vSJpdLfKDb7Rk7GdghktO2rcut8VC7xIBRrN98Bu9MdRc0S+qSp4hBPBfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 09:33:31AM -0800, Dave Hansen wrote:
> On 2/27/26 16:44, Vishal Moola (Oracle) wrote:
> > On Fri, Feb 27, 2026 at 02:24:33PM -0800, Dave Hansen wrote:
> >> On 2/27/26 12:07, Vishal Moola (Oracle) wrote:
> >>> Do you have any more comments for this series? If not, could you please
> >>> take this through the x86 tree. Thanks 🙂
> >>
> >> From a 2-second glance, this doesn't have normal comment style and isn't
> >> using imperative voice. Quite a few "we's". Looks like it needs some
> >> more eyeballs.
> > 
> > Ok, my mistake on the comment style. I'll fix that.
> > 
> > Sorry I'm not the greatest at imperative voice, I'll pass all my comments
> > through AI to convert them all to imperative voice.
> > 
> > In regards to more eyeballs, I've realized I didn't cc ALL x86
> > maintainers. +CC the rest of the x86 maintainers and we'll hope
> > someone else looks at it as well.
> 
> I was actually kinda hoping you'd be able to actively go out and find
> some reviewers other than the maintainers.

I'd appreciate if you could give me more guidance on this. Who am I
supposed to go, if not the people from ./get_maintainers? I don't know
the x86 folks, I interact more with mm.

You've been giving valuable feedback to ensure the stylistic choices
meet your expectations. I have mentioned I'll have another version
*trying* to meet those stylistic expectations.

Mike has been very active in reviewing the ptdesc work (thanks!), and
he's provided valuable review about the code itself. I don't know about
you, but I trust his expertise on the topic of page tables.

So, I don't even know what you want from the "more eyeballs."
Do you want me to email a bunch of people unfamiliar with x86 and tell
them to catch what you (or any other specialized individual) would
catch? That doesn't sound productive *to me*.

This is on the x86 mailing list. And honestly, this current iteration is
simple enough that anyone specialized and interested could have taken a
look at it and to provide some feedback.

Please do let me know. I'd love to work with you not against you, but
that's difficult when you don't provide any guidance/pointers about the
issues you have with the patchset (or process?).

