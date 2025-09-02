Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E2DCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0D326B0012; Tue,  2 Sep 2025 05:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE49F8E0003; Tue,  2 Sep 2025 05:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFAF96B0023; Tue,  2 Sep 2025 05:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC2E86B0012
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:22:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C721058A30
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:22:19 +0000 (UTC)
X-FDA: 83843769198.04.8E82945
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id E5C03140012
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:22:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BBjWTJ4H;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756804937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEJ7Ey14mWS9ux2fnI3lv4hByDSn+Z0hPpiKOiV6hv4=;
	b=TSkVfh+iY/GsvWjr915asI4IgMpXWfAGEINGRXDyUOaLdY7DjOr0OvOdM4JI2eWQpkJoCh
	9kLLTVJc6SCuoeGMX543QDm5jbQwxj39MJ/T26P12F2CgdJdGx/sWvtTcQbo5OJBXCxASh
	FK6C7nA7tHeyAwUljMnoSpy2ZWZ4hDM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BBjWTJ4H;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756804937; a=rsa-sha256;
	cv=none;
	b=wyOJDCr2GEy0UXoR7YkiyS3bB8YO0iuCwOdjSthL3E7NRTwm2/iLB84HwNvdrKqKqnOEXF
	ENeFUqQSaWWn+hjZXHrE8SlUVebNKCsMMq0E/B65Flv71nYPZlZdYzXJbAdBf9ehwUuYix
	VrAGdInKj0gwOlZ07I+j//c1n/KSzpc=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b327480fd0so849601cf.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 02:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756804937; x=1757409737; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UEJ7Ey14mWS9ux2fnI3lv4hByDSn+Z0hPpiKOiV6hv4=;
        b=BBjWTJ4HkfWj3PatFIUrbxTpMb0tF1XUrT1Wdi7IOtZZLlZDFLYBuXmwpc7NyYOyBD
         9ACqCVnRbqufPjiHyaP6u0A+PK9LnukXA3oD9Sj/APThSSGIRMxNV92+9Kxy3xvCMaEQ
         MhzaaYgfSYJ3Y7dFKHjJylUxC3BzhUOP38vzNXcRkxJnwibkWdYso5OsZS1cF63Ro8Z/
         YzWHy0ia7saUeDARdlIK/1NA1WmJk1H8O6oyW/I9k0okFr2tumJrb7xMWipi6JiFy76J
         0XZtKYGvnZLpDbGSsk6/ph8yhJSAmasjzQC2hZ66zV5fXKZXX5qzb6eyRNHtYeEyLDFo
         dOnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756804937; x=1757409737;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UEJ7Ey14mWS9ux2fnI3lv4hByDSn+Z0hPpiKOiV6hv4=;
        b=mHc/fPPrl0A91EFiOyjIeitns1mjjchL02BhXbTNFvyYVq8rLqes3S/fznkwrtKuVx
         EIdHuJwdx+w7rexf+JlK8fgjKsMBCiDCmrV8P4IZESNmt0U6PnY19B8AQ2Yhv+B+m6o0
         i3w9E74anNEj+oAjJjfYVsSina+CLzb5a/qiWIVHuJVrsrKf5YB32SmyvzQphxaidi1o
         9MU661HWR0Eu9RlFcdOaUahY5xUtgi/R6EfJt9DvuAenOP70aHuouS6qh41Otp8kfqsO
         RvtIK9TyIerEkAw+xEb/J8OjJGMZDLmSamQMri5fa7a5OwvgXNfmp3Cl7nvhQU06nTQq
         OoPw==
X-Forwarded-Encrypted: i=1; AJvYcCVk8qHEfSvH57ifhW+OSODHJBYcE7FGKM//FWESh3C9lx9MCFCrXFQM0hh2B8xwL/OXuiQJE+sKRQ==@kvack.org
X-Gm-Message-State: AOJu0YyUyqmM/sutUtfEBE1FHF6rPNYKqKPlUlMoy5F1seXk81DXhsnN
	M2WeKe0uKL7POBf8NpWYMvbdEf6jcsgl/xZ+IJsetuNtCudqfzpSDpArpMN0gFZ3whsV2tZBpQT
	8IXjckg46Qkq9FiUTfg8R1sXBQClZirKYrLkdMwsn
X-Gm-Gg: ASbGncvqBjMe0578LRKfmfkvFfqRU7dgcRwGZ5bxrKcrYyA+/xx9uTfGYt6UJCU9YSM
	mARQNh2ppIal1k4XV94MOj5wU2h9aMYvaXrooJEqRr6kBDeq+6T8WslAXDTMQzxy8eH6+Tf0+iF
	Kqo3eWNWili07W4OpgqjwDJFaIvOXhKFbTssI/Yx1dcDNEHE8ukhPQaZAZm9mbxGPJlg4LxquMt
	oOiOpXp/raHGlQ=
X-Google-Smtp-Source: AGHT+IE/365ZPa2na0I+61w5kSKHeQK2w8xYgvB2r/DuNmzeiSpIrPg40UHX6ZyJ0CzihYKx7admZMRUkLUk8hCwjvo=
X-Received: by 2002:ac8:5a56:0:b0:4b3:8ee:521b with SMTP id
 d75a77b69052e-4b31b0e2753mr12638851cf.0.1756804936638; Tue, 02 Sep 2025
 02:22:16 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EHjTxymfya75KdOrUsSUhtfmxe180DedhJpLQAGeCjsum_nw@mail.gmail.com>
 <20250902091810.4854-1-roypat@amazon.co.uk>
In-Reply-To: <20250902091810.4854-1-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 2 Sep 2025 10:21:40 +0100
X-Gm-Features: Ac12FXxFB1Y6AnaQmou77bzNFiPMi0bpB9wRe5PhLp9QE0Dg7CKdLpI-R4eIPWU
Message-ID: <CA+EHjTz1JxOy=E3p=So2q+k=UK3cDG6C8gOUgA9NQEpqRdhW5g@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com" <david@redhat.com>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org" <will@kernel.org>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E5C03140012
X-Stat-Signature: uh31atqnsisupwy5ociwmdj97jju4xcy
X-Rspam-User: 
X-HE-Tag: 1756804937-2403
X-HE-Meta: U2FsdGVkX18RjEbGQA35ecUT6uo2nJqJwK0Skie/zuMbvfjDTD10Tv6ZJxniRC0O+DnSB+1/s9UNKQIil5IJ9NiIjHpo3B/0kGhX7nXeUZphEO+uLrkooQwQdIETAwf4W4spuG4tmMLB0hZDqjgMHlmrZK4K8FKOXmtqPVVgX1KbLaJA4KxNANa477+6WF6TnKbcWRXmfY8+a5hjAexlddaBnfB7aqCP9H1wOcPn+kL7W8+qKZBKhS/NVZ8gWlyZhkP9FdmveEp2XW5e0N8lOTdfwnGvsYSTHFNjS1MoQG6l+HNhyhZ5a8j323xjM7IMo2I5ZUfK+Ay7IpAs+BeiKAtlEfPd66kznfGaS45uQdWtWPtsy5YSIFnil/TiCIWFjI0p1ZHGhGucT+QZyiiCbYw1WeP0Mx+doFSAgfwJ4kGFtLBKivBlEIv7bAefBBb/iR1MosjnpolilSVEZPJLSJ2bIWCgKaIRrx7idfaXVYIRT5uaxAvaIECijzs331dSOKJ3XDsB6wroPfB5p1GI8kGB2d9TEK8aOzFbZzIjNunIs8wlTr21ICbg5cRGmNedLae88pQkC5Nc1CrirqbuyL1ESyE9/A4VzrWpxFK3LhKxRJ5/0B50Ab1psntoeVpSoKgQBuw2lJChusJcWo8ZBZa8ipJRachtN8nwdi3eDaDEb1mxlzZ6+FGMtstEMInCPvZkHiV6mzdyeUEjug72pbwc80/DUv19jq9/weUcPuWddVjYdtA/i5B+/T/8vgaczrFPwpnw/GLRm/o+LfJ3sWosmmA5yGuuay4CWS9GMfeiFy/hz02Kf/m5wwgKYoj8WdrY7SqMur7f+dhqm87Oahz6/24yDC1pfmgB4XgivAVj9eM6BrB8072KNVsPkV85sFm20i4WnGgu5xc5hZlkk1bV6IbaFyvPRVlBkjstaA/nvQpJpM48t//m8UyHjUGdEm5VkR+Utd4K9r+6Iil
 pfL+4sGu
 Bof+Q6imVFiRKm3Z8j8oIJ7Tb6KrITktVcVESbs/vwTL3DSvjpeoShlDvDrA/+raXAAVI/mKWbOItJOZGnxjABfFCjBnIfGgtbbV1ATntiX771+LJgutZNLgKv/22dt/njGEqxjGlgeesXSE4HS/LVR1TOz0RETZFFNKjPlTbSLPvrZngel1xJH/6GIUvdgBQHDczLjJ3fNqAw/7AP1d1FjZ8ZME3mhEdgcbJHooODBHrv8+hhWow/G/JDqHS6uSTLhvECplvGgbpRDgrI6/vBPMH2EMfgpbWsLcYgTCq6GJEOnAL3MKP3FiC+ilyrMlhpbS/G5p/XTacaalqCrxyFNRF80E+AkCy+dxvp+sdWAGpQ+ogM7D7fMCi/W6r1E3DJFfOxdxDDo9OU3pdqYhL2wLXj6tY7I9+R2vv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Sept 2025 at 10:18, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
> On Tue, 2025-09-02 at 09:50 +0100, Fuad Tabba wrote:
> > On Tue, 2 Sept 2025 at 09:46, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 02.09.25 09:59, Fuad Tabba wrote:
> >>> Hi Patrick,
> >>>
> >>> On Mon, 1 Sept 2025 at 15:56, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>>>
> >>>> On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:
> >>>>>
> >>>>> Hi Fuad!
> >>>>>
> >>>>> On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:
> >>>>>> Hi Patrick,
> >>>>>>
> >>>>>> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>>>>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> >>>>>>> index 12a12dae727d..b52b28ae4636 100644
> >>>>>>> --- a/include/linux/pagemap.h
> >>>>>>> +++ b/include/linux/pagemap.h
> >>>>>>> @@ -211,6 +211,7 @@ enum mapping_flags {
> >>>>>>>                                     folio contents */
> >>>>>>>          AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
> >>>>>>>          AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> >>>>>>> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
> >>>>>>>          /* Bits 16-25 are used for FOLIO_ORDER */
> >>>>>>>          AS_FOLIO_ORDER_BITS = 5,
> >>>>>>>          AS_FOLIO_ORDER_MIN = 16,
> >>>>>>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
> >>>>>>>          return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
> >>>>>>>   }
> >>>>>>>
> >>>>>>> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> >>>>>>> +{
> >>>>>>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
> >>>>>>> +{
> >>>>>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> >>>>>>> +{
> >>>>>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> >>>>>>> +}
> >>>>>>> +
> >>>>>> Any reason vma is const whereas mapping in the function that it calls
> >>>>>> (defined above it) isn't?
> >>>>>
> >>>>> Ah, I cannot say that that was a conscious decision, but rather an artifact of
> >>>>> the code that I looked at for reference when writing these two simply did it
> >>>>> this way.  Are you saying both should be const, or neither (in my mind, both
> >>>>> could be const, but the mapping_*() family of functions further up in this file
> >>>>> dont take const arguments, so I'm a bit unsure now)?
> >>>>
> >>>> Hah, just saw
> >>>> https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@ionos.com/.
> >>>> Guess that means "both should be const" then :D
> >>>
> >>> I don't have any strong preference regarding which way, as long as
> >>> it's consistent. The thing that should be avoided is having one
> >>> function with a parameter marked as const, pass that parameter (or
> >>> something derived from it), to a non-const function.
> >>
> >> I think the compiler will tell you that that is not ok (and you'd have
> >> to force-cast the const it away).
> >
> > Not for the scenario I'm worried about. The compiler didn't complain
> > about this (from this patch):
> >
> > +static inline bool mapping_no_direct_map(struct address_space *mapping)
> > +{
> > +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> > +}
> > +
> > +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> > +{
> > +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> > +}
> >
> > vma_is_no_direct_map() takes a const, but mapping_no_direct_map()
> > doesn't. For now, mapping_no_direct_map() doesn't modify anything. But
> > it could, and the compiler wouldn't complain.
>
> Wouldn't this only be a problem if vma->vm_file->f_mapping was a 'const struct
> address_space *const'? I thought const-ness doesn't leak into pointers (e.g.
> even above, vma_is_no_direct_map isn't allowed to make vma point at something
> else, but it could modify the pointed-to vm_area_struct).

That's the thing, constness checks don't carry over to pointers within
a struct, but a person reading the code would assume that a function
with a parameter marked as const wouldn't modify anything related to
that parameter.

Cheers,
/fuad

> > Cheers,
> > /fuad
> >
> >
> >> Agreed that we should be using const * for these simple getter/test
> >> functions.
> >>
> >> --
> >> Cheers
> >>
> >> David / dhildenb
> >>
>

