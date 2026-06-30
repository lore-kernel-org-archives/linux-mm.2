Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50EB3C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF91E6B00A6; Tue, 30 Jun 2026 18:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAAB56B00A8; Tue, 30 Jun 2026 18:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A982F6B00A9; Tue, 30 Jun 2026 18:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55EB96B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:21:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C556D1661EF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:21:53 +0000 (UTC)
X-FDA: 84938002506.07.D7F7F79
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id DBB3D1A0006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:21:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WUIPmvmh;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782858111;
	b=K3Ec2BgGyLCwdYD4al4n8zVYBoND1U98BrL+2jiqcaJYVdYU0GTROX2Tb40O8v71nW0VNM
	XfysFWOqSx8ngK5epMrnb70dsthVO9tsXSmIPoR02dU/blxJRjQ5YFW6pRNcdLnykluU8+
	W3Oa0QJrYNwiIH/EIP/0RAzd4nepGzM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782858111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DR0tH2IO3fN80hPp68tJnACbZx0ZviQ8SFdx1MtberI=;
	b=0YEOV3RIqMLY1XqUeQtgskZ9X2haftWGjyBhvpcecjEc+Qc3RlL02I8iM4iwrqNwjpDdv5
	/T+pwPmyj2EoNITXgLbwtFIoR7MtsmYYi6w28r8DirBvNgXfuNtN7DNsD7D6NoPNqNFqTr
	G66YuuCL+FCw37scIpu1Eps7w0+2GNQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WUIPmvmh;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-13b32f48e98so290457c88.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:21:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782858111; cv=none;
        d=google.com; s=arc-20260327;
        b=X2RmY1sYjXraMu8Yd8mWFHfTIdWVDgzarCy5CQDYdCw/fWJNzFjRCVSCokokUksD4h
         BPc/Zhqy7/8USUBybHS2RFadKAmyHkIqhNALm5jcEhsSUVTLLl3FDqUBobbzJZkg8451
         zngs08lWo4a0Hw37HvBd8vwnMQoV+oAQkpVQF+pndHmAZGbSr/Z4EePXnRABWQOzJW6E
         EdEqcSCFSyJwEf6/IUzxHXM0Xcn2LVDmqowl4F1u1Vv/UBIoKpncDoe4+AGb3riZm1SF
         xxFMorNv4YRNQe+gULNDPyKzd1+M0994I6E1m1R4HjuHaCAPHQ4ld/dlloPkVTd7NMzv
         QOXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DR0tH2IO3fN80hPp68tJnACbZx0ZviQ8SFdx1MtberI=;
        fh=Xr87+eclkMUtzo8mmVFMgKw5ApMFY25kXW3OzTS6n3c=;
        b=R2gVTaKcYUNb20CrCfMzh0SkVIpFSelpCrIAXHV5GP7B8LAtMwjs0uYpGdtbs9edbr
         LoqJrXOw2YWTDYkrLdzBbbtomTUM5tEO9SvBz0KJTDIMhEMoiXHJgPiHDCRR5teh6QKh
         SO5rKJsapMYnlLltilqMAwMaIlJ+WpWfLYpzkx6a1n4ouXrYP7Uo9ZO+aAabrRmmtcMU
         8TQeV1m7vcziqbzLOaeDvoHIziITuiyNCGb5+hhdaLr3BFg+hz5kTkwOH0TChzHub1oZ
         y5w1kAYCHlo/HDsVl8+DI1IMMCSuIViEu5A9/ZAVHeC3mrJdF3VCndLkHT9f7KCuaYqn
         yPUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782858111; x=1783462911; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DR0tH2IO3fN80hPp68tJnACbZx0ZviQ8SFdx1MtberI=;
        b=WUIPmvmhtwSceKEaX8Vx973HNgVA9oQSTMOZVJyRIL5hT9xR7lAjY412mTPKQMK0iz
         vNCRyEkyLUy00Yk+eYtcQ98cLX3FRXKHuP6h8m8kXXEz5xWvB6gBuLY8qVORKRmcx0Rn
         RIFiHsyHkAs7pClwYz2EfZxQHGmmq7TxLyMc72WqBtHuIzlyUeCIT3/HMbzhI4Bnw5Oc
         qf9LXnnCkhKqlhHstFZMWD9AjveSm5fuhyosLUB6IpEMo2zoOQaNbW0pCmNB03aW6I8x
         JTXbYoJmZOJtkj3korvT5gnXwZNwdQfmtcZtYgxJlW4xGVQWbEQ9FB4GANCBHFfqJVqN
         0elQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782858111; x=1783462911;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DR0tH2IO3fN80hPp68tJnACbZx0ZviQ8SFdx1MtberI=;
        b=Xb9O2/c6ezbHPsID8WmsQL4ni9hiMS7jW+Q3jAEGvc9Ckn1vTT03Mraa7V0clJo2hB
         L6Z/aOVQglOGDw9rDSDWCUJdfL2hgzQHiwEmDof/+5Dwt78vSxodFttbIGhcBbz2tZGm
         NOAgDRMePYCiThcF+HltcFx0WIREQtmwsWAM7Wq7FkEZKAHtpBAcMWsB05nDUNeYHRDE
         h6wvs+qeUKeDTG0wDOi52ZvdWKZFYAem9z65xbZGJsmjt/H+UjWb/1RB2ppFVbmRk7Hc
         rQ6jwACQKfeBw3gP1wvTsJyJBQg+y2jbv3tDZ1K5e/wjGBMVW0nOseBMAflE5WVMynKR
         3pHg==
X-Forwarded-Encrypted: i=1; AFNElJ+VXDRCmVh47HL6xRsvk5sD5L1EG/eSGTG/KQsbZZCX5m18D9kJiKkEhyufRIlpCnrZPpifcbZs4g==@kvack.org
X-Gm-Message-State: AOJu0Yzsktg8WskKVXpdl+i5uaa41E/J7TK2X0MSgir/HJUJbbUKfjXy
	AH6NZvyTsGk3IriYJ78+DZzEmYo+mtR+S/ZWZt1vgGVBMrVVoFnDA1O6niL/poXp+uI3RBhzxJ/
	jcVYnxdkYCHHuuDLSfexTaQKMgh1N/cLECUTxb9ms
X-Gm-Gg: AfdE7cnlTSXTKrF3yd9QhuMaY/e6yhdmxqPwFkks+szli3HZSowiOsJr+qTnTXNprQB
	b60S6gBLkCzI52yX7PBU6b5AgBZWVPusfBqOCXOpTVHCgrno15HDg3PifAUN5+Ao7Fhwa6P2a0p
	NceIYU1o4H3rwq1bJLfRzW9chXbi6bt/3Z9xEj52Bjrap36u+qnE1Qb11G/XhHb5pm3a43DpGrQ
	+IbS3gXd6hPGqw2cYeIMZxd5EC6rqmcYN2Dx1QrqwI8EXJ3lmCGgTyw/QgbmAyHGuZFDcc7
X-Received: by 2002:a05:7022:923:b0:139:ed5d:5c9f with SMTP id
 a92af1059eb24-13b2a1c08bamr3407677c88.40.1782858109859; Tue, 30 Jun 2026
 15:21:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com> <20260522202410.3104264-9-dmatlack@google.com>
 <aiXWmR-ettxin4LC@google.com> <aiaeOVomxQZhoM3K@google.com>
 <20260608181640.GO1962447@nvidia.com> <aigtS3UDdhUGp3m0@google.com> <aigyn66-xQ_9JBW6@google.com>
In-Reply-To: <aigyn66-xQ_9JBW6@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 30 Jun 2026 15:21:22 -0700
X-Gm-Features: AVVi8CdGaAQOsRR3GiQD5WoDqKgNzoVt-sa6rd2Hjmz3ldGohaSjMHvZ8NY85tg
Message-ID: <CALzav=d-JD6ZbUNEbRMQwnvOhCBJ3ruodr3wbHM=1WA++MCKCw@mail.gmail.com>
Subject: Re: [PATCH v6 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
To: Pranjal Shrivastava <praan@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DBB3D1A0006
X-Rspam-User: 
X-Stat-Signature: gtrih346udytgizmw5o44i61814ea6do
X-HE-Tag: 1782858111-304820
X-HE-Meta: U2FsdGVkX1/6BqVkD+fj2uXpDnOuPG0oVkl4fFSOVQTU/4+0F8T7DLqZug3UGV09XTO3Ak7GzShEdqGJ/RrEL+NwjY8hehK8VIO5P2+bVVJxwU2u95VBRJDEcxqF5gOlya/XL2WvI9uyR8rE14d9GpazoMCdOk3qBwwWJsEBwxJ2ueSvy8NmAhxhVNabO22fjkYWLfXSpytBVPz8Uwgd50v5yvqJ9jjGj7q6bYUGD5grC4RTOrLpCbMr9F/wRhB23gPp8Cy5uiavy84rOQ03ozdn72AYxMjnLQUCvwXS/Hs53yhGc7Vmc25ZYwyGbC1UHjam926tDmB+S0qI1UR5Os+3mK++9XwzK/D54Xx1/JVEC9hckxh+5QIyhnhjJN/VBmhFMb6supQjD9Rf7ZD85QnNh5ffapco00eH/R51OjE1PcLfu5yuouw278Fpd56VmlPjHDEAdNQkifHGtx8NSBPWINPv6mSV7FZ2oAHe3nyvotO6zg9RJgYEeoh3pESTWUcTcZkROdHLIczdX9ZkhndR8iIERstO+ChlmeriXF/eBWvi5qCARTTyM8VkpkGgaTfEket/HP27sTdSX81bHUMTzcGwXL65tXDsvtbiNpZRkb2+ABQ+MfEPKJQ0wWhepbyJ34CUPCnCKrnPSl/zFGUR/hprIeRLjbqLhDPwZLRQ8JYXk87GBO8Wn+0r6EPrZHFgTDrmLa84VGE79SnlYtCRPOcYwT86GOJLFuZafby2AWwjuwliimvaP+TxtCytlCk2tqsGmbvzSLtWH2Vv5ZqMlw9rXvlJKxtEFOQ9JvkkOXHvhaOEp4szVyoCsh1Kf6nSEGML7HFQoP8UMB7JvftDh8ZWooNQ6aeu57aE1mXGlU0bKHELxA0p48snf7v3EJXoXUgSFV+XKFdMjBNyXJsPAvKELbtzdO4rRsn7TvIVS8JNs0NkYFREmxzyBjzqR3SPBIirJAT38lITv7I
 ijfG8NCP
 HJk6GZDUtMWrAVCh4C86Ou0lp+kpFNBDpXdvBRYCq94ZmSFVjY8GlR3OsYc2q7p2xxn8d76GqudSfq11j8y4aemXGtW8/U9zk19t9GX6wZZ5E/SAdmbBQ8I/kF35MRlMpTdbNlBOJCqIlhBSQLXK5DheKYGpdqGJic9pWCJCMmiVdspLV10iMxGMqPEEqoneiiL6qgjBB3MLsk6sc6QO1DXTVOlsR9G1USYX4OmZGP3rZFelv62e9XjqLcABIMcsWFcFawEnTcltMujM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 8:35=E2=80=AFAM Pranjal Shrivastava <praan@google.co=
m> wrote:
>
> On Tue, Jun 09, 2026 at 03:12:11PM +0000, Pranjal Shrivastava wrote:
> > On Mon, Jun 08, 2026 at 03:16:40PM -0300, Jason Gunthorpe wrote:
> > > On Mon, Jun 08, 2026 at 10:49:29AM +0000, Pranjal Shrivastava wrote:
> > >
> > > > My point was that a FW exploit can meddle with the bitfields of the
> > > > ACS_CTRL to spoof and mis-report the ACS flags.
> > >
> > > Devices can also ignore the ACS flags. I don't think this is an area
> > > where we should be worrying about devices being actively hostile.
> >
> > I'm wondering what happens if we preserve IOMMU groups across a kexec,
> > but a switch's ACS capability is dropped or the ACS_RR bit gets cleared=
?
> > The incoming kernel assumes that it's the same ACS cap from the old one
> >
> > Now, the incoming kernel restores the groups assuming they're still
> > isolated, but the hardware no longer enforces it, silently allowing DMA=
s
> > & breaking isolation?
>
> Again, to clarify, I'm aware that we aren't preserving IOMMU groups,
> the incoming kernel has to rebuild the groups. My concern is that if the
> ACS_RR bit is cleared during the kexec window, the produced grouping woul=
d
> be different than the old kernel. What happens if two devices on the
> same bridge were assigned to 2 different VMs?

In this patch the kernel reads PCI_ACS_CTRL after kexec to determine
the bridge's state and uses that information going forward. We don't
assume that if ACS_RR was set on the previous kernel then it is still
set now.

So if ACS_RR were cleared during kexec somehow, the new kernel would
see that and place those devices into the same group. Someitme after
that (I'm a little fuzzy on the iommufd restore path during Live
Update) the kernel would try and fail to restore the 2 devices into
separate domains because they are in the same group and thus the 2
different VMs would fail to come up.

Of course maybe ACS_RR can somehow get cleared after the kernel reads
it, but at that point the issue has nothing to do with Live Update.

So that's what would happen if ACS_RR ever got cleared during kexec
and seems reasonable to me?

