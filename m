Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDC9CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 22:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57578E000D; Fri, 26 Sep 2025 18:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2EC78E0001; Fri, 26 Sep 2025 18:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D6A8E000D; Fri, 26 Sep 2025 18:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE448E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 18:00:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 306C811ACBB
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 22:00:23 +0000 (UTC)
X-FDA: 83932770726.25.7A1FA67
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id DD82EC000E
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 22:00:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T+HBKtGx;
	spf=pass (imf22.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758924021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHus9Nwm7AbTe+6Nurck5vYYCcXMmbdwrVgh9usCgx8=;
	b=PqPyBxvwFmQI3YhGJa4diwiRybyv2X0VLgAUmz7U4EcxnPOjF6dDNFFkrL83zhunfVKvM7
	JMdK7p8lY64ijGcl+D1poCd6RJLst2HvshIAmvu2kfcHEvAMmr2iI6VuSfYSEc3jWSnRzA
	RGpdTnHdVAHes9U6LlgWeyBow4AeHhU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T+HBKtGx;
	spf=pass (imf22.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758924021; a=rsa-sha256;
	cv=none;
	b=j3PyUrItTeOFenTv4+WdnmqSlOb5rVVzXZpaS9dIi/FUXVkA5MriJSzZ+etbQeAv5fqM/8
	H93y9wekkHsV8JEyegeaMQcdnWe6ryP0Tq7vRTfvlrH71pc47zXZRNbP09s2+9Yz5DbNKZ
	3/vKuzD5m10mHWrKkoZ+tg0IrbJHsgU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758924020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fHus9Nwm7AbTe+6Nurck5vYYCcXMmbdwrVgh9usCgx8=;
	b=T+HBKtGxW57Q2irFFXoq9/kiB05SEW41U7U7qTfzA27nUH8u0OMcVuBMmMLDmV8OtaUqhy
	lnu9yUn9/mNOUkpnjRnX4nwSMt2KD7HzkwWIA5AXWQkbcP4LB/v4HYd+HYHm042j0u0xWc
	u9+jRSBWeo+7ISBEUVC7wTMz90rzduA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-f7AhjV1wM-eXFP8XOepWsg-1; Fri, 26 Sep 2025 18:00:18 -0400
X-MC-Unique: f7AhjV1wM-eXFP8XOepWsg-1
X-Mimecast-MFC-AGG-ID: f7AhjV1wM-eXFP8XOepWsg_1758924018
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8589058c6d1so345399785a.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:00:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758924018; x=1759528818;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fHus9Nwm7AbTe+6Nurck5vYYCcXMmbdwrVgh9usCgx8=;
        b=inz0WmqjSj0X9QS8+n9Z2UCPmcSNf/TLwOtazUKciWhvj6ik+8VM3cCxr0O+PZoOVY
         Bk2JgiNB5SoBmPbIaS49yxF70S0xmGV1dIM7qgj8zv/E/eSFCX8VQ0PHy1blH5NCBb6V
         mdiIf52io2RlHjU6v3ik7PixZBAZNOiruFKx715HS4PC+KWptsG/ghfxmmWp7KlF3VJZ
         p33Ou2x+iaKPFuf98ZPhJl0v6GGvNB85JXYItcEFbh9XHPN82VqhqA3IHaPOCnJ+wnmW
         HamRCHIhWux9tEbl6JEuzh+JXOp6cdpa40N+B8KAdQabv/jKqrdDJjaItUlRJRUwBFdh
         Dfgw==
X-Forwarded-Encrypted: i=1; AJvYcCVwIb0+8I+yCqYhwz6a4fQ9Ba0zf/eEFJJaYMHmbHttamBCWkmgItCcN2ZTE8eTgfKaX85vRucg2w==@kvack.org
X-Gm-Message-State: AOJu0Yw3TQMSmvczRDc64c8X5CQ7glCZVdXb7OJEYbEFl7ElvJFYb5W5
	WONZ5jy6Gxw0LY1Qr3kmuhvhFnC07bl3iZjcwE6w9zyDGvi541gh3O5EPg8cQXvtMu5iLxl5j6u
	CvY8v1Dv5NBsMInyHHtZrPHkhkhzdGo7UUvl+9Q3o4myZyIDSvOiV
X-Gm-Gg: ASbGncuBdWVDAyOUJZkqk9QpeA8VWCzBBMh8/TAm6zykxWm0Y9bf7+3gWHCP1RmVlce
	U0tDayV+T3yh5rpCGRr4jW3v7ZkT40fy2NbGegREBfYlm9FxBv2jrjnySAByCdMyOC/jLRogoqV
	S/A9CeCru4222+O5MZAXTJbXAyccTIX45a+k822xC+J4Q06Pi2rN/AWNuU447/u4tXHlhDhJuIZ
	BtsIp3EtdxYtZIH3kE4OCBjjCylUC+FiiYL33URo8p4HEaGyTNWOY+ZIm5J5np4uotky89gPfRu
	+Gf3Ps9+TTPPnpqQocyUAZAzO8s+qN/H
X-Received: by 2002:a05:620a:3950:b0:84a:2c73:7534 with SMTP id af79cd13be357-85adf3e7e31mr1152212385a.7.1758924018046;
        Fri, 26 Sep 2025 15:00:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGiEIFT6Y43UZ9lV42YbkkbGE0+hlc6c8wgWuacmAg98vw0vIVR278rBAv47JnGCCo4FF5UNQ==
X-Received: by 2002:a05:620a:3950:b0:84a:2c73:7534 with SMTP id af79cd13be357-85adf3e7e31mr1152208085a.7.1758924017616;
        Fri, 26 Sep 2025 15:00:17 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db09f19dc9sm32373711cf.11.2025.09.26.15.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 15:00:16 -0700 (PDT)
Date: Fri, 26 Sep 2025 18:00:15 -0400
From: Peter Xu <peterx@redhat.com>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: James Houghton <jthoughton@google.com>,
	"David P. Reed" <dpreed@deepplum.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range
 fails
Message-ID: <aNcM7yqj36u37LFv@x1.local>
References: <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
 <1757977128.137610687@apps.rackspace.com>
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
 <aMl4qLyNovWHhty9@x1.local>
 <1758037938.96199037@apps.rackspace.com>
 <aMmMnfU-Koopc9mL@x1.local>
 <1758043654.112619688@apps.rackspace.com>
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com>
 <CADrL8HWS7h0e0AcjbE0npoVwqvWK6c_aqML4T+MJnTkCz5AcNg@mail.gmail.com>
 <CAJHvVcjznC9KdMDMLPCP7W5Aq_u3GobPVZQoUF=wrhUN3OL9VQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJHvVcjznC9KdMDMLPCP7W5Aq_u3GobPVZQoUF=wrhUN3OL9VQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P0iKZdbqBbO7-cDltXlsUgKjjxpL6ZNJSogzxFwsXmo_1758924018
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DD82EC000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9kwn9a4ooipfrrur3tpqq7hqjs8dcykh
X-HE-Tag: 1758924020-281811
X-HE-Meta: U2FsdGVkX18BkAfamT4GHO60Lp72Rllfw04/K2XDhZVEwjy/XLXFMsAcu4NjVIe7ZECOeXrMOKHsM8ljE5LEQvT8ky7TtGHCJkM4GNwJuiHu830AUwZW8eO/RWNyjJua2j3HQijlHP+khWKEOUdK9cdFnft5SFB/BJW+P6ojhn0Bv8AMTIVog0EvNhOdEFYiya7jo0y+elRqMFC2nIc0ElNvkD8buo4B6aZaT/DpmetWHibc9z03IwQ3QiGelSvs2qfHYzbyCIRms7/T01+v/ykh+5mmgBxgh18nQC5XuFFgErTAoUxG1vYbbM+lkOgXQSxYTqjVEL/Af1MIkY5QxKjtyR6U4qf4OEHv22jkfBBojrBw7DzQNOMDFWoU08xEqcS60o8QuQyI0SV2Pbx4wLE7/cxi8ZPRijy/h52s6ElsvbOYYq2tihb1N/SN5JKL7DVGZH3khnKbaHP7equ2P+CLU2sqnyZXGDlIdiBDK50QdTz902LZKBt7DAFPza9hily0f6tl6HaCwF3kPtn8GH/TCA91qNh+wpJ54we5TGPZxyrI/OPmSTSMKKrLkK3N/jtV+JvTpPCRIgHm5UOnVbJdnjEtK0Ivq7wmmkshE7ohCJw1IXOIP1okw+Wei7RiF+Jusogu1KIg7beWp6sNhmLhcTMHxRldgBobNG0wtC/rnbO+WtzUsr4OU1X6PY6ox5TMWIf2eC4jOU+4LahsqUfTa4TTG2bl8tJEmBjjOV0OoWxgTsSzwWaGi9pqh6ZLj91paR7yuCd4RZXh6fXOBTo54WHZ0o3g9IwPt/iOCXZaA8WXEMbu9od+ljHXalrq4sLaFcRIYhdIALUqBphd78AgwceIFR/GkfOkjARHkgLwPovivpU1YdkALBxL8GuTOz+0k9SanYf5pG+SEwIxmvPnMhdp1C2sgMx10+pU6Akv4Lxu1+R1I7k6tpZ69tnDxsBh/zgNBrHHh+cbyI+
 26vG1k36
 HKbHOyicL0djl9yAcPebtubY08oCA6oLksjaPeuDsDbcVM/hySTpNdBrHeBTvmxJkY6nCfxRBMGWj4US0e9iwDtVceO/PWYYzzoYVyXbNKKJeKyRyGrHSqmXEmVk35lj5SrBSQ12g3KRXUL8+ez9eIu+7WwghHpRCltTnzoukkGRo32eKJxuISmHQAkKu6/ieKGxDySgem4of1sxKauf98ICCC/INqz3lVIiyVQtAevrg/lMp7AK6cgETc+j5FNATcA3SQVYVCxhXQBB99a9No75dhQgm7jOiWlgkVSloS/Y8idnqpQUH1i1pR0BEUMohvlgT2CBo5TY+DaTKxmb8Y14KZCFSHxXDGXvYxBaQD8ogXka/lE1xjawJnIhFtyFuIfffhh9LqhnPJNogiCRrmPtVM+BoEeYLbfTxLTkQELTQ+hcG3yBw2/2O3K1UYIUSRCzjUj4orCY/qGAIWxOfhI8Hg4Ajo4CJU3F1oDlVLLwPoV5kr0d/MYdGsIeTxtisRFWXOePPoKJCu645/MG0CFjn7uhIoZeTIJOX6BK1uukjaR3yqtWBtujZyPsWvAAivBCInWMFCInGpbx6bSgSITA0g4gSPwikB9PDPRDNDu6k/QU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:04:46PM -0700, Axel Rasmussen wrote:
> On Tue, Sep 16, 2025 at 12:11 PM James Houghton <jthoughton@google.com>
> wrote:
> 
> > On Tue, Sep 16, 2025 at 11:35 AM Axel Rasmussen
> > <axelrasmussen@google.com> wrote:
> > >
> > >
> > >
> > > On Tue, Sep 16, 2025 at 10:27 AM David P. Reed <dpreed@deepplum.com>
> > wrote:
> > >>
> > >> Than -
> > >>
> > >> Just to clarify -
> > >> Looking at the man page for UFFDIO_API, there are two "feature bits"
> > that indicate cases where "minor" handling is now supported, and can be
> > enabled.
> > >> UFFD_FEATURE_MINOR_HUGETLBFS and UFFD_FEATURE_MINOR_SHMEM
> > >> In my reading of the documents, these seem to imply that before they
> > were added as new features, that MAP_PRIVATE|MAP_ANONYMOUS mappings were
> > supported, and that the "new" additions to the MINOR mode were just for
> > HUGETLBFS and MAP_SHARED cases.
> > >
> > >
> > > Actually minor fault support didn't exist at all before those two
> > features were added. :)
> > >
> > > You are right that userfaultfd's use of "minor fault" is (unfortunately)
> > slightly different from the meaning in other contexts. I think the more
> > normal meaning is, faults which do not incur I/O (i.e., swap faults and
> > file faults [i.e., faults on non-swap-backed pages] are major, other faults
> > are minor).
> > >
> > > For userfaultfd, a minor fault is a fault where the page already exists
> > in the page cache, but the page table entry wasn't setup. I don't think
> > that scenario can ever happen for anonymous, private mappings, so it
> > doesn't really make sense to be able to register such mappings in this
> > mode. If you create a mapping with mmap(MAP_ANON|MAP_PRIVATE) and then
> > access it (read or write), that fault requires allocation of a new page, so
> > userfaultfd does not consider that a "minor fault". My recollection though
> > is if you make a file on tmpfs or hugetlbfs, fallocate() it or whatever,
> > and you MAP_PRIVATE that file, *that* registration will work.
> >
> > Ah! You're right... MAP_PRIVATE *is* supported (for tmpfs and
> > hugetlbfs only), and UFFDIO_CONTINUE will, upon finding the page in
> > the page cache, install a RO PTE for it.
> >
> 
> Why does it have to be RO? I think it depends on the PROT_ flag you
> specified when you created the private mapping.

It needs to be RO because we're installing a page cache into a PRIVATE
mapping, hence we don't want the private mapper to update the page cache,
we want the 1st write to CoW there.  I believe you wrote the code. :)

Relevant lines in mfill_atomic_install_pte():

	if (page_in_cache && !vm_shared)
		writable = false;

> 
> 
> >
> > But what happens when the write comes after installing the RO PTE? My
> > reading of the code today makes me think that we'd get a minor
> > userfault and then be unable to continue...! (The only reasonable
> > behavior is that CoW is done without triggering a userfault... I
> > assumed/thought this was the behavior today. I wish I had time to test
> > this -- I hope I'm misreading it.)
> >
> 
> It's possible my memory is wrong, but I don't think UFFD minor fault
> handling really interacts with CoW faults. IOW, I think you get a UFFD
> minor fault when the PTE is missing, not when it's RO resulting in CoW. I
> think there we just CoW the page as per normal and no fault is reported via
> UFFD?

Yes, even though I don't think PRIVATE is a goal for minor fault, IIUC we
support it, a CoW should be a follow up if the minor fault is triggered
from a write.  If it's a read, then RO entry should start to work.

Thanks,

-- 
Peter Xu


