Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE59C10706CC
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 11:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1529D6B0088; Sat, 14 Mar 2026 07:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E03A6B0089; Sat, 14 Mar 2026 07:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24606B008A; Sat, 14 Mar 2026 07:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFA3A6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:15:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B41C5B998
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:15:46 +0000 (UTC)
X-FDA: 84544413492.23.CBB3475
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6F92B120002
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:15:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b9tzWljP;
	spf=pass (imf29.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773486944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zcMk2juHKP2RohK/1BK8E8XwH+Ave8HercTkx4NfKUI=;
	b=VIv2uFTCIXkIgKsrLluFaSvW72FygyJXrdfwsApcGKAqHsVjz4WoyxHoX7IEwDsyeSg3TR
	tNmYceTh5mzZm67Wts3rfuVCUpg45PF9JYcwzH+Rzecn5rnDS5DXFLTPoGqU4wPWYonPcR
	IgGP3+J9NRRqWS2lonfhp1aDhfQ++uc=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b9tzWljP;
	spf=pass (imf29.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773486944; a=rsa-sha256;
	cv=pass;
	b=Do3mb1SsImdxvAi/vGODTm3DM/nzWWlPIx4+xkFmHyb/mTqvrtRnraPXxq4+YUtEpy4h7y
	i681hRhm9eNYRT9KKHr3h3b+ZgDyzOk7NI/ZM43V74qxBNbY/2tZAoQr0FXWi5aa0YY5Q2
	30yWU3fA8FE8xivilqBjNvjF6IvlBFo=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-439b78b638eso3194893f8f.2
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 04:15:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773486943; cv=none;
        d=google.com; s=arc-20240605;
        b=Xie4aehUFYxwc2aiZKjGtMblO8GXhkPH7x6C5yRiN995k+SOuf314FWam2auQ1J59b
         JjPlT1485W//nX9tShKLzpuun30iVkcUaG1hReWlNpsvcQizb4+3NXEmIeEMIx5s7Mgd
         T2k3POvZbpuNbBgiRRqq03OUoVzhDRPCYPSeYJcDdZK1Y4+Gb30PLm/uctUoVnXtUWOL
         KiTt6qgawpAFJA//hMTN73t7hq7Q6zz6pO5FhVkEncuNogrCRbsYgzuWayHEZBVpoKOk
         KAuOAUEb4KWxVyXXOGFnIYHuQjc1nYNhuNE+EkJ9/MPoyKlq3X/yUJlZUj5Dc2hsuX/b
         mHdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zcMk2juHKP2RohK/1BK8E8XwH+Ave8HercTkx4NfKUI=;
        fh=6u0xg8EDXqiqAsjfcSO7AgbtKn9AtbeJh97AWq0ticE=;
        b=De/HVkskg4NHur1by51adzLdaoLSNtjBgdIT+Zdg8QPy/X6RR/Ks++PKwgI0g0y0rH
         FQCR/TH49sFoBrS/NKDnpwUQD8zhNrFHr7OxLLvsK1Pnkli3gUwxVozn0NaRVjsM/MGq
         WUfkwFoNkT60F21RDatqsvQNDnGYGsZ43SOj6GBqeAcCegT22vRjNHXTZ0oscsiSVpBe
         iTHQ9E9dWg8PGrTttp3mVXZ+PN10AUDb6PIApjMf5d2KVAAm+MECeT9MWCedYHmf3KbT
         ih9OFzyAEtDqUuNWajpYe3gifL8KoI7eOJydL+lKIq2v3hqdOeo27Odye1Q3Iyhca1+P
         zNhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773486943; x=1774091743; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zcMk2juHKP2RohK/1BK8E8XwH+Ave8HercTkx4NfKUI=;
        b=b9tzWljPHt9dXdsGL1tiiOzP7P4MEyicP6z6sapBL5wp+iOFh5m+PGq3gGUfovh2Z+
         R0jNGsFzPXj1LsNmhIOvN/POdacb3DhEpY6TjzPC1a8J1Jphk/M74MfQhON8cAWDAZAH
         2J28ZfToQ11kL15lycxK1b42m8LAlykV/pOSUsuertN8qCafbFRq9nU+FGDg5FulIavM
         CyDpesMdv+GO+jkXF9KFjCDfSgmscnbc18Q7zdfPw8NECyx6aNskKnGJcMungdHqSFUM
         JguqbMeNVC6IddDWfvHV0KRbKODf+CofZbmHHFvGWVVg07L8QTcCb0Drt0iX1j7/IwfE
         5gEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773486943; x=1774091743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zcMk2juHKP2RohK/1BK8E8XwH+Ave8HercTkx4NfKUI=;
        b=QAR0nC/BWC43ctbtqa/gsa/EKPYfJ1pQSQG4rMISD/RzSOPKVUlzg7F6a5tLIZu1fq
         0XnM9x+MwNQIHK0XIKMpA9vBk4RsIOERBriRZAOyx4Ra2PX9EK2D6gttv5ZtHQj0ZL8+
         IBPaGmIoX/YpipRODMv99F5bh5cLMR9n8Rd/YhftpPZCfhjMyA4YqhSWOl12RGlxjEyv
         hz68GG/T2GTiKfBA+ao2ZgjupGC4OwYe2R8MuEMhkuwrxueFPyAj8yKJBjGpaW7UamFv
         syzFswrllwxc9fgeXPOVgncrZJ1j3Vk5bexPXp4Vsd9u8esSQnHAtp8nQfCvPOmenFxV
         ByTA==
X-Forwarded-Encrypted: i=1; AJvYcCUfqOYB+XTCZLd8vjOMNUDTgkX+8dYwciH3RCFCd4HhoOriI3mlYzV/F7P9aJ80wOKOmbpreilLbw==@kvack.org
X-Gm-Message-State: AOJu0Ywwsh4TkewOoqZppXV/Gk/NeBSq+9lg5qVoN47jnFJfRMT+cN3I
	IGkbUR8bXGuoC/2ce2EV7Wt1j934HBU+WIuOC7mr25WAL36CGabRAszXuGy3i0CrKdlTcnMvReF
	R6wXlM8qhW8YyvsWklAddNlcg8N2VJ6HKF7x6cDtc
X-Gm-Gg: ATEYQzx4yk9bt7aMLt0zYa7mg0VJbFy7ZPkutDruKitJrwsyQxcMFGO4EtzNNxKlmIp
	Mp3pVPxqg+u/TDBLEpHI0TgwfkhZWnI/qNfzPiOTb1Gikcc94aRG4FohqexKF25ZvMcenF42bHF
	EUCVa0nJiEpd6WhquYXc61S84/GiYXB1s7sRNyMYxL+Dd1Qzxw+P7egfwjBRg2ZPvMqeeoQFIye
	Ut1jl7gAa8f/eGhlVl3uMku2C6mivyTK3d2yt1nL2BKXX3W6busoaSR7nU5QEUbuKfNsPHQs5x8
	vUrG7/FptMHerLh7IdHhtniannUu+NmsmjvzpQ==
X-Received: by 2002:a05:6000:1ac8:b0:439:bc79:9f8f with SMTP id
 ffacd0b85a97d-43a04d14d83mr12829860f8f.0.1773486942418; Sat, 14 Mar 2026
 04:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <202603121235.tpnRxFKO-lkp@intel.com> <20260313213638.GA147391@ax162>
 <CANiq72mzEzjNg7O_2dWT_6QOJvJ3TwV+HyxNd_F4j6v9C+pc7A@mail.gmail.com> <2026031422-catsup-rectal-f886@gregkh>
In-Reply-To: <2026031422-catsup-rectal-f886@gregkh>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sat, 14 Mar 2026 12:15:30 +0100
X-Gm-Features: AaiRm51ckUfgkRssBsogIj0VIQkDe2Z-Te-pFSaEkqjwee_TzN5cwYkr8WTmMWw
Message-ID: <CAH5fLgixE9MGXxNEnU5b0EXdgLQoTs5CMv_0OdnfCX3v=coUpw@mail.gmail.com>
Subject: Re: [linux-next:master 5585/5731] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, kernel test robot <lkp@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Mark Brown <broonie@kernel.org>, rust-for-linux@vger.kernel.org, 
	Miguel Ojeda <ojeda@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jann Horn <jannh@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F92B120002
X-Rspamd-Server: rspam08
X-Stat-Signature: dj9kk7ebeejdwbhjra9yq1hgmh8xu57m
X-HE-Tag: 1773486944-705751
X-HE-Meta: U2FsdGVkX19roRVAdwxcJYEM/34A8thLnAKzce4qvs0z3Zel+KdzgWnSLr4nj4tkJ+i+KPek/Ce9Gn41nOoNIu7wLOBbrejY/Tqn9ynw9j8MIbrw2Zl75V0nLUw0UrUHfIrQAFvi+Xe8ghd4Yzk5ZBe4k/DV9jsSOixU4MfkQv1kyFNTXSMqGdeEhwoJV9kimfZuSOAtTKzzzH81DA39xd3nZNAE3MbIJ+DI86ehyd5jruvMCbhM89zXbs8i1G8n8AEt2c++gzBCOtacMYEZ8i4zYuMe85D+Ad6FfepFjDUn3+p+c0zJm1c1nyPqvsEvHeySVIPDt8kLqDbox5FQ3SfCLljAAzPXbyIDuUqQlwieRmThE/ZH+Z8ocDNZ+9mHss08C2b9r+I82Woab1tEftXyf6P8FfhTHzVMw3NcNdpW8vIyDlQFIsZdvYKP8YPQRPjPjQ0KIAQotlNjfjIK8Z3g8wBbU9Wh5LWMLKHK9q3Bi155sQBseHHOrTHuQS5mRzURSyBS8k4XqwqmO5GFUPtk4MuqeSpBL3dLZGaBb4TPXXJDk3o1FbqBl71bHEhiRT7zlT59R2Z+NZ7qXc88MrC2mHvydhpoAHO9U7I4WHrpVwATOyga89tCJl/HHhWkbh1dhnz1GIZRHSRYqGftvvuQYKR+HlbtAhZGJeiW0HPAMGVhCsXkbzpQXgpgNbc4Z6DojF7F5Lm1W4bOUhTr8xrcy2DgY+72P/ERXwH8ohd5kQosc0iCdjEXdMdz23RCLs6Ih8C42xE0QV3ehbbBkzVXcawCBUg3A5YcHJmhA51rkrNtoXKBkciLdAl86AM1nnS/izGZolhicvbG8Kbb3iDWUFenQvSixTUdYR0L6iG1qkY23vYgqUBGsF8QqZKGGHHFo0ReANmp5YjUISLYkWyshGER1eOZsETWCsGzOSnXnhU8tWsHg6KUfsVDt/0LTF1f2bgmTpdmoIgZAtC
 zwM6hB0M
 gfUqwTU3gT+s+rEO13J0xAWJlVLVWVCn6ozec6utG4b7VpOHWdKFdFpbS3T4iCT3AtbJGawY8X8wbzab3qqHRSOyMzNYvYMB45wnyx6yPvbsk7J7uu6sTL094EEGsFx/5y2O6mvU2JJcG6feI7o0cwfUgoHUN5njkYWqwNbxCLoBKu6QV4MSTX1gX+5XOPExH6StMFXBaI1s1q+rBl7+70FnwmmBsqS6QsuwEkAwV2sqOf9niKvFSlSbYOyr+dCJvG+2qRikVDiJAJCgUetyjEl+9MUx7pY2GWPTsra0yzR3azTLSHHx/+33aJZouUgxc4wPHZHDmlkeSAwvN3zKtfWd1rDgop5uI5UUednwq25KlKDS3CzfGq8VJHC3taG+KoPTuae5ExS7EwTeMbaztVJ5idwATSvg4mZgi/V8vtm3Mz+XmB3hMHW3M6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 14, 2026 at 12:13=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Mar 13, 2026 at 11:39:14PM +0100, Miguel Ojeda wrote:
> > On Fri, Mar 13, 2026 at 10:36=E2=80=AFPM Nathan Chancellor <nathan@kern=
el.org> wrote:
> > >
> > > It looks like this is a conflict between Alice's "rust_binder: check =
ownership
> > > before using vma" [1] (currently in char-misc-linus [2]) and Mike's
> > > "userfaultfd: introduce vm_uffd_ops" [3] (currently in mm-unstable [4=
]),
> > > hence why it was bisected to the -next merge commit.
> >
> > Thanks Nathan, yeah, adding a raw pointer (not function pointer) to
> > the struct makes the type `!Sync` in Rust.
> >
> > I assume this is best handled with a patch on top of char-misc-linus.
> > Perhaps creating a wrapper to assert it is `Sync`, since the
> > `BINDER_VM_OPS` contents are unused (so far).
> >
> > Cc'ing more folks related to the commit.
>
> char-misc-linus should get merged into Linus's tree "soon" and then we
> can fix up the mm-unstable change for this.

I'm working on the fix as we speak. It would be ideal if it went into
char-misc-linus, because the commit that is wrong is mine, not the one
in mm.

Alice

