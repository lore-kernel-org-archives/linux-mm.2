Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF77DEB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 18:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4AF16B0005; Mon,  2 Mar 2026 13:36:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE816B0088; Mon,  2 Mar 2026 13:36:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0396B0089; Mon,  2 Mar 2026 13:36:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A68726B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:36:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23B8E13A574
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 18:36:12 +0000 (UTC)
X-FDA: 84501977784.21.FA86125
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F4AAC0006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 18:36:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QOpaFA+E;
	spf=pass (imf22.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772476570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNGbC+n/FkqePeOY//UBg6AI1QctrOX8iaSRimJodOQ=;
	b=nDoNsOAFMrI69z3KmU+TBDRnsKysJETWaQ8Dher8yhrP6NjWMLFo0xIApUA88D3qYrtq+i
	O4XhlKItbT/ITTqcDlQnANDbgQHmQsTRQ9d5rasCgLYZawLU396TqPHpg3zH39epqiCK3j
	CInkhV7NW9Yx18ATWa/DeFRF44VeYl0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772476570; a=rsa-sha256;
	cv=none;
	b=OS+QdTC6ovbAUxcc/3cWRL8hCRgUvpN/ttAc27GNJ6tD1PE1wYxQtSb9I+wcmdc88uaokC
	52TTm+32gub/k2vJjhxnRadu6FKHdbJppqROPivnh61g9Ov8/ExKpMMKN4TFmMgq9ZHs5j
	vSeeZfqJr0TYBEarYMV4wmfsbOxB9Gw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QOpaFA+E;
	spf=pass (imf22.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ae3f822163so8125ad.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 10:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772476569; x=1773081369; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TNGbC+n/FkqePeOY//UBg6AI1QctrOX8iaSRimJodOQ=;
        b=QOpaFA+ECiIcJfO9Wf7lV5yLA/fh0K9S+JFqDi9J2f+aPIGp1RFALn8dP9AbqovDT5
         3gOFSh1vEo7y+mDd5fmg1cn484PSJlkT7K4a3iT4rLFPf1SW+272qejYjMYvcbKMKj/z
         KPd4xpLu+Wnh4HB8ObOo7KU8X8FST1XJlpF6a0CSqTdOMWbAGhIOeIanyF6sq3+GqX2s
         2X1rP3v/dr+1u5Af18fNQ+Qmm2apVlinMquQ3RW0qbfQH2DEBEZjKVyn/Gqe0CQ3iLvN
         R5a6rguNQjQoLAAUuJN/Y8nFnvUF039dXGZgC7J3KagAr899FlQ7VU4l/yIgHuhip6XP
         V6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772476569; x=1773081369;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TNGbC+n/FkqePeOY//UBg6AI1QctrOX8iaSRimJodOQ=;
        b=psgHwQI81+ooEhsSIIRKXz/qsCv0ix9i3CtOLJ7GbqKXFndPA3qoe9I7qQpVOE6AvE
         aX8npdNCJewFOms9hHd8j/DmHI9tbCdPj4YoO34I4CKZTt7plUMBB0aaWU4ieJo7DKYJ
         v0JbqYaVbirE2AZYG1Zm7FGshMHi94KwIwsyA7yItPusU/lHhUK/ssNmH6mwnb/2v3ia
         UM7NPw4OlKIaU0MFOfKp1S9bSj///Nc6wEr1O19b2qPmclxYMN98UmHlfJRhfltRojQr
         pj7EUAusB24eGItvK0hRQIECxWmE8nuLNkqLM52YtuL2SUXY7yGbQrjy8QiuQs8pFaSS
         etkw==
X-Forwarded-Encrypted: i=1; AJvYcCU2MgCA1jcSLcan6sKdQJzMB69b6ExZYeVN9I4FhtQURZuc+7QM1tBwAbqvrdCTSSRnWEgxodtAEA==@kvack.org
X-Gm-Message-State: AOJu0YxYmwxbTGfGemaaXWhMxTSo5I3x4/TyUfoKvCdkH09FduDq74Ao
	aP8QVb40fxz/m59WZ1N5CcZVzY3fyCI2TsRTkktOU1SqyFJ8/IubTBy/mIYPSJYbPQ==
X-Gm-Gg: ATEYQzw8PSDqMTd3JX+6MD4KoFO5kuKWNQcqChhPYP3OdUZbm/5voiUfC47VjPD4owa
	tC27k10sxCZxjlNBXzmsVvVHstKgIyMINRQK5uer8EuijiKJPbYq9MN1AcUfhSBp3+yXpkqQh9/
	nyXj70Kr7xlr8QUmIVG9YB1VWbc/jSmfFL/wtL1Eel7zL0URfGcK8eqjiOnCmE3jO0rX8SDnWaq
	8eYEcithsdxpHlixLTjNQl+3cpkrSLyqKmzqFovEjqf6fZQ2Q+zltqYLKjogj4US/y/0A3zBJqi
	qnpzO9BJt0PzHEIgl3J/3uvJfUQdHOYDw8z+9749jIX0NRVKyLtqok6ustYy7/1wTUaN0zb5ylk
	IIpvEnvC5tMFafdEmV5xoPLo92yVI8Xpd130SLRZBI/+yuiOVTI/4TkVgtLnevOpIsZ3uBX6z+M
	Vd6C0OdpWJf5YUU9ZOFMdX6eesvKUj3X9Rm1SffVDHNjr9zYwWIKndwJYif0LAN/V1dyU6/sA2
X-Received: by 2002:a17:903:1b6f:b0:2a9:5ef5:399b with SMTP id d9443c01a7336-2ae3b553cd7mr4766455ad.19.1772476568598;
        Mon, 02 Mar 2026 10:36:08 -0800 (PST)
Received: from google.com (154.52.125.34.bc.googleusercontent.com. [34.125.52.154])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739d94de6sm13941615b3a.24.2026.03.02.10.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 10:36:08 -0800 (PST)
Date: Mon, 2 Mar 2026 18:36:03 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Jann Horn <jannh@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rust_binder: check ownership before using vma
Message-ID: <aaXYkwQ0Yg5b7sTb@google.com>
References: <20260218-binder-vma-check-v2-0-60f9d695a990@google.com>
 <20260218-binder-vma-check-v2-1-60f9d695a990@google.com>
 <aaXGZlfAmk-DCuBW@google.com>
 <CAG48ez2M4fj15gqyKrP7ADRUhNQZkpy9m+NSz2N=vo=PSefm0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez2M4fj15gqyKrP7ADRUhNQZkpy9m+NSz2N=vo=PSefm0w@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: qpd8qce5du6q8kj37jwaigda1z3ueap4
X-Rspamd-Queue-Id: 2F4AAC0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1772476570-696676
X-HE-Meta: U2FsdGVkX19GZYMjsLowltlklCYrGIaf18SV9j4PhRpYkpE9bSJVBe7Rs9Y7yzMAzhkrDP3IRofm6Rl6ohF42hjI7UCti64gBt2izdzn+mPwStziZ6/UI42YyXrzt5CVSpi8ukHUeQ/jiqNrpanEeVt2PWgYc1fKZNv6cvS01JyMeRoTb4d3lCtB5kHt/+QiX2Ik5b8XL3SuE+BLHdPYgWfF/9MIU/R4szshr9JD/hKfFJuXoSlvwDgQ1rMF4XOV0DZjfomsIGJdE/U//rB+TaD7QCs3xaOFJWqbzAcc9M8Y3CZjfKoZifsCp3kNt9SyOwvgYvgJ4rQFJO0xnMWk8uA0xIj5rWcua9rm7Qh6yCaxG127g0uzFI98OlnTaCpUfOnHDDqEGHOoq8eBmg1ZXsVrgRX1wVnU2W6P+cm3HgsmEF5NS+goLBBpmG7FMefnXYFki4uyA5Z2uDJYBRShlVAyKAf1mhsgS3lHRU7sWRdsaS3QxSyXmEIPmIlaOuH+VwlYuM3jVIYIpegBVTUqtnLSppAYWL+URb+hj6mW66eruEbOyr5WKcoyduICeLmnmcSdwnaxwJQSH7UIsqTVmGuQkrZYDkDtLqQaONbdLEdGj9RyvSLSGPZh/DkGv9RLWG+O2OGhepNfyw6UmQ4XPo6ud7h5g23ZcBLK5R9cS6i/0jo2MoR9+L5rqI0KFw5c88KIMQspsO6B9E34CmYunYy67XHMmLZQHxXjJL/BqQX/pNJgHKm9zTsqCKOzXFTHuGRHU+1TkehqrZt3NVgNu9ArmO7aX7r2nKNyJ7gc0Q2NdsUkHSeHt37NNmaktHGN6v0DS/1suFdh2AJf2zalkH38ZEPUqrYktjjeIDebdPfqyF8wFXB9rPvwyA4+BYlAcCpZ8YaGPlWqGPWT2wsH1zhWrE0/mdwI32fg0zPbVq3JPQ4aHZc7SGzJMtE5l3LotwN4OaQm2nroZ2jev3C
 ksgF06e8
 jBruIguifkLFP8p9U+Jydhls9tXTPc1cmtTYlie+8UpPiDHDq16vaCFFmwDg+PM+uf6j4xrucn6d9fq1LpIsCuLWSTX+9ODGfovsEcFEF3RmjLwzqPC2pJ2haeHUFhnX2+oFKPe2V9bNPHAg2MfkR181Mv5pfAdSVh8X4A6GbPEVBMh5t+8r+ZBV4aTPcaApKOYl3QZ5tq0Qr3qItMULmq4rj7572tfsNAj71xMdG6X33bb6HIgQpExJkQQNI9rn+lQESE6JQdnA1O96BfGI0R2Ry1hK5ZZn5B/mfmoiLTRpTx6ERuZYQ8AbDQFsjeXGRzv/HAuLZ0PeqZXMtuWN9K/ftrIpUc8aaBY44NWPvK7CmH1Eg6LPy6W0fwDQd/1K7nlNQNMcq9tzj7Tp7Y7uFPSeSn0LzixKlF7VbmPMxI7sKZlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 06:28:17PM +0100, Jann Horn wrote:
> On Mon, Mar 2, 2026 at 6:18 PM Carlos Llamas <cmllamas@google.com> wrote:
> > On Wed, Feb 18, 2026 at 11:53:26AM +0000, Alice Ryhl wrote:
> > > When installing missing pages (or zapping them), Rust Binder will look
> > > up the vma in the mm by address, and then call vm_insert_page (or
> > > zap_page_range_single). However, if the vma is closed and replaced with
> > > a different vma at the same address, this can lead to Rust Binder
> > > installing pages into the wrong vma.
> > >
> > > By installing the page into a writable vma, it becomes possible to write
> > > to your own binder pages, which are normally read-only. Although you're
> > > not supposed to be able to write to those pages, the intent behind the
> > > design of Rust Binder is that even if you get that ability, it should not
> > > lead to anything bad. Unfortunately, due to another bug, that is not the
> > > case.
> >
> > This all makes sense to me. What I'm missing though is why not reject
> > VM_WRITE mappings all together? Is there a downside or something that
> > prevents us from setting this check?
> 
> You could, and it would probably do the job (assuming that you check
> for VM_MAYWRITE instead of VM_WRITE), but I think it'd be more of a
> surface-level mitigation than a robust safety check - in my opinion, a
> robust check should, at a minimum, confirm that the VMA being accessed
> belongs to the right driver, because other drivers might do random
> things you don't expect in their own VMAs. (For example, it wouldn't
> protect against interaction with a driver like C binder which reads
> PTEs back out of the VMA in binder_page_lookup(), makes assumptions
> about what kinds of pages that yields, and writes into those pages.) A
> driver should not be touching VMAs it doesn't own.

Alice just informed me the VM_MAYWRITE check is already in-place:

	rust_binder_mmap() ->
		Process::mmap() ->
			try_clear_maywrite()

I just wasn't aware of this, sorry for the noise.

I also agree with your comments. The following two safety checks should
be addressed by binder:

  1. mappings should be read-only.
  2. don't operate on unrelated VMAs.

(1) Was already covered and (2) is addressed by this patchset. So we are
all good here. Thanks!

--
Carlos Llamas


