Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72FF9D61011
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 12:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDBE66B0089; Thu, 29 Jan 2026 07:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88D96B008A; Thu, 29 Jan 2026 07:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A614F6B008C; Thu, 29 Jan 2026 07:24:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 909396B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:24:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 274E45BE16
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:24:32 +0000 (UTC)
X-FDA: 84384919584.17.A169E6B
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2812FA0002
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:24:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cG1eXBV+;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769689470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gi378VSufP6R0w8KNQPQBwzIrR72NX7nC7xLrdysx7g=;
	b=HBPB4OApwfy2fUrx0wY+CeCtAowMCY2+BQgbaElHpB1OB7QFmjerQA7hmgkn3PIlBFm60+
	47PYUqYpL1HKp5gRwbC4550JHBQXMABXx2U8TOelCWP8/7DZEyOcuTdqrhCWFYhQ+1X5j5
	KAnRkR5R3/Hx5Se0g0DwGLxbpWuRPUc=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cG1eXBV+;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769689470; a=rsa-sha256;
	cv=pass;
	b=hHJ5V7Sbxe2l7NVfg2xEKSNuBngv9FZ/nZZgmgK8let4YWT/2WQYDZZbxA7plnJnePDPlO
	GvHBN5PrZSDcCuN4nGxAgSAEBHyfVfP4lB27vKVEYzOFP1q5x+wqqAcQyt81iQb20R5jph
	ZlPs7rs066S0XRB2tD4vbuphrOBOew8=
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-385e7cafef9so6973191fa.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 04:24:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769689468; cv=none;
        d=google.com; s=arc-20240605;
        b=eRy06smfqZqoM2ndLTM1bVh/v6ttaTqnYhMvqEOCLi8W/aXOWEiWWxmfu7BnrdXjoK
         pKdHk0ETKEo4CYIXkjwOU6mnN4JU+dE7RIGeyBTB9ZcOqJczAi1lFpnYEOJHXxR7hX8b
         NlnCRnUUS/h7XxWMSjEkCt1B1f4SKxZ5RRYqDNE0SFLqqs2ppgs1MNo901ErQvQBYryG
         it001H2J7Mh7cnr+TYrU5QoyNI/b6k0nJV583Io5f/4kD10XH1a2pN2pfJ1yD6HMy+L6
         /dWgu6jxd073UKtggQI0iBCxctFcDkuCSgAm0VwUPzhklIdWfCPXKKcWnjNy3t5/bZOR
         QsiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gi378VSufP6R0w8KNQPQBwzIrR72NX7nC7xLrdysx7g=;
        fh=axh3yBTGQvfrf6EpHyJktaMV2zpclwurKXoGNMx0J4E=;
        b=fef97akfbfO7eaPPJsbo2ufVdXZaqT/Seyi5ypQRIWm5CLksWCMDkZVmFv2As7Jmrk
         qUe0KzRwSdoWCLx+QSeeMPous4gVt/nRuY2xd2rUgvNT8nfrPmUvG3H7+4paj4XH+Bis
         VfnIcEd/3XEbQqya1wX2C6YMyDYMHRWit89Te78ZmBxvFs6ClLHWe5Bm9PHGy7mTHcd+
         yiG3TgkAf6NWMhRkS5/Wr/wk3bLPI56PeoJ/BjZuFFetz49J5ch2bxII36h5wwVhL495
         EpTtfcpxHMXQs8/0suhITAYfOm5KW9IH+PVoprmuvFOkkIBhwKQkHWUcAArheJucKQ8H
         jROA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769689468; x=1770294268; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gi378VSufP6R0w8KNQPQBwzIrR72NX7nC7xLrdysx7g=;
        b=cG1eXBV+tBsOt2LSaKYhukkNO+Vq1lyimn6m9+5XHMc6g9DBsvvf2RwQctIqtg1OV9
         cKAw96Sjgisz0x0Zzx3qyya+t3fnwgEN0qeaybmYiECaTb1sTIFojn14CQpcZeInspRR
         A5oVCizJljAr3Tbra4HC7DVs9lW8ftHB9A2Pv8dXeSwyRbwwjvyTxx5EwkkV3/vgfcpL
         RVK4lDmcUEzwKk+GEv8Ux0WHpis2sYphKM7jOOG1gFOnmSg7raoJ5m3wRMQacFR/VmB1
         IVDnFeHiB++5T154J8HCRbmY2zvwczba8GkX5IbdJ+uPmZyNAnVBeYrAmSZu0IHosShQ
         74ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769689468; x=1770294268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gi378VSufP6R0w8KNQPQBwzIrR72NX7nC7xLrdysx7g=;
        b=lVqLfnC4PFSE/MjRbBUbeCcKZydy/ToQvK9eWodq3j0Ue8tfTBvnBdiNVx0ZGgSjPD
         M4pIvqGHAVUGGNDmp3TkSmwBNVYvsLAfsMs1p99NFo7solUgwbCuQ2VzlY84XOSer+6R
         mdOn+5TOwL/69AtdVPwqSHpjSlzzfZpd1zIQ7jiJVCoLTJjrC3vFGrE7gqZg53f6Axyl
         fWPJvUDdLk6cSq0Fotc6nWCvF71VYKx+LbdlG1sX4P8Y4uXsd3RATgGgyg6hsmCbtAfi
         vxE6K8KK5EHDqUFgGgk779NZo++RFd0BDIJ0LJrUYJQLHfUBKtEhDWW0WlMwLG5UsPNN
         l4Zg==
X-Forwarded-Encrypted: i=1; AJvYcCXQiRz63s+1hkGwZLtqULM9ElBV4h6uwfy6DdMD2/m7URmHoXIITFWCMkrWXJwSeEscezISNlLn9Q==@kvack.org
X-Gm-Message-State: AOJu0Yw1nQ4AqJ6RUSusnxzesFb4kN6dZCdhS8k3Bit4huGRYH+DLnWh
	iL6lwZoG9BmbZqapmZ3jodXAfw+P5WVv4pnTF346azGzRkuNttz4DfGOv+01Ctsv9amE0/Hh3EK
	UTsW0IjsUEvMdmnQqmLMRZ/dx7v6dfyo=
X-Gm-Gg: AZuq6aKRxsMQ2+AC5TNdk8JD/xLBp9mBC8GJplnAnuv8g+hL71r7ekR6iVnkOCyomjU
	uK8aa+7SQ0Iw8mytoFElqx8D3cSLyBED33TNAD08CNPuSlmlqK1zPiZZIIURgN4cZdiS6haHd+x
	BP0j7i3nx+CfyCBBVln4G2b0mC+f9NXTsUPvQkjUGfBrcbBmrabAY0M4cLLYR9EGlI/i5zfiOK1
	oN7A6jePZapp8O0AtmbA5r907+p86s8LN1uu1tcN2Jbn5KCx80RArUWZQZyscfnjlsy0Kkp9Fya
	Ro9sIXQ=
X-Received: by 2002:a05:651c:2205:b0:37b:97b7:a049 with SMTP id
 38308e7fff4ca-3861c85b3aamr38828881fa.9.1769689467768; Thu, 29 Jan 2026
 04:24:27 -0800 (PST)
MIME-Version: 1.0
References: <20260123082232.16413-1-vernon2gm@gmail.com> <20260123082232.16413-3-vernon2gm@gmail.com>
 <72dfd11f-dca4-447e-89c5-7a87cb675bda@arm.com> <4exllw7pf4yfhfzpyg3ictsnznf5lepv5tjd7zvycldjwmh6jm@j6rara3ogrux>
 <7c4b5933-7bbd-4ad7-baef-830304a09485@arm.com> <gzhittxi6dn2o6a3wf4qx4fafkdc2pumfuz3xtprh3ifs2t47q@slsfcb6kqqcr>
 <dab88ab4-2580-444b-9ea2-579005de71ac@arm.com>
In-Reply-To: <dab88ab4-2580-444b-9ea2-579005de71ac@arm.com>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Thu, 29 Jan 2026 20:24:15 +0800
X-Gm-Features: AZwV_QgCm_qUWXIevjF6S9ifwEiu5F8yYa0kQ32R7XGDwTwd6hCqXNzQa4rcjbg
Message-ID: <CACZaFFNGXDK7S82q2bCbMt_0UOa--xi85kwJFcj5NtNpwmW0pg@mail.gmail.com>
Subject: Re: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
To: Dev Jain <dev.jain@arm.com>, lance.yang@linux.dev
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: ix1r1q7ckiye1piefd45jqf69hup5etm
X-Rspamd-Queue-Id: 2812FA0002
X-Rspam-User: 
X-HE-Tag: 1769689469-585096
X-HE-Meta: U2FsdGVkX1/7DE0U3se9L2nZr81FYpB4NT+fqgISWMXN8zxtzAs3sSASmy83W0nL+xYXYevvRnxKNWzL+5ElEcUpgCfFVGLaCuGUvgSFjZhx4UW/VZraI26PQ+v/SNagb6qdRMoPGjyhDRSN1SMm9JvHQMSUP99WiDcqBpM5l3U8q7wvaZGFhSZYLZPYCtlD00VFGfX9tIhEEgUY7XXSc48RWo7p8s4Di0C855WIvz6sTSDEVCJh70W/WKvwl8B2bxuFRxWbmuPigKSmtgC5k8Yk3WA+L0/pq3iHnu5w7Mpxf9Vvx4Bq/AlrH65KdvkoRnZ7WuoxvZ0E6jolLX/Jufd8cQI9e+n0bJeZiKP0TK5oYwgQZufs2E4j9GoDosT6SNdl7K2w/RmaUAuhE6DgDq76ruK/WwvzPIOjaaFPl3ZVFwVAlPCNlZl56xa3zvAZ5lnUk41Z/WPJUhzIlBAaRH1t0de/6bYVEw/6ni7ktw39aQYksU93kGpIyqUyz9OlryBahV3th3azj5Wg/2mAubD7XZhJ+p55Wgb5U6vomhGG3BKGHSWGZqNPiDG4qhBi72h0D5zOpOa5/gqSmaOKLjz4Fl6snvqwrz0RtRXF1oAs0une9LNO7bJBnqYjY855nTrPaDvlPTAmbJkEMmvv6h/sw0GLDn69GkoxW9jkFRC9dVaeibWX95EEhHrvMK3Ktb3erLH1sJQrdhRRVeBoNd+9etItutiwVoxnZ8AJJZr/mR5ZoDfCFaeq/PIwu5XpN2Dtco3Du9RYrp5jo2AX6uNRZh9o96I8HjmhRN9EYYMjQwXU5NkfH4DFvgxt5t85Dcv13J1yKqN2KkC7qDsungHBnSV7NzcgZgoGSgWJatfYgd7KoTNvpvxLnh9QmWr2eIxY2wbTbtZ1gQxSnA7kdGFWf0zSitGS6gHFXD9FXtS1k/bEt229LynXSjWuCd9eOsHNXfdY6DnBu8B4SCB
 AG0i542h
 NXQMNGKlXOb6wEBvanwht9gPf0a25cg6tTGPbTJAzu8SbxqDq/g1fNg4tRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 4:32=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> On 29/01/26 1:29 pm, Vernon Yang wrote:
> > On Thu, Jan 29, 2026 at 11:05:36AM +0530, Dev Jain wrote:
> >> On 28/01/26 8:04 pm, Vernon Yang wrote:
> >>> On Wed, Jan 28, 2026 at 01:59:33PM +0530, Dev Jain wrote:
> >>>> On 23/01/26 1:52 pm, Vernon Yang wrote:
> >>>>> From: Vernon Yang <yanglincheng@kylinos.cn>
> >>>>>
> >>>>> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> >>>>> even if only scanning a single PTE/PMD entry.
> >>>>>
> >>>>> - When only scanning a sigle PTE entry, let me provide a detailed
> >>>>>   example:
> >>>>>
> >>>>> static int hpage_collapse_scan_pmd()
> >>>>> {
> >>>>>   for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >>>>>        _pte++, addr +=3D PAGE_SIZE) {
> >>>>>           pte_t pteval =3D ptep_get(_pte);
> >>>>>           ...
> >>>>>           if (pte_uffd_wp(pteval)) { <-- first scan hit
> >>>>>                   result =3D SCAN_PTE_UFFD_WP;
> >>>>>                   goto out_unmap;
> >>>>>           }
> >>>>>   }
> >>>>> }
> >>>>>
> >>>>> During the first scan, if pte_uffd_wp(pteval) is true, the loop exi=
ts
> >>>>> directly. In practice, only one PTE is scanned before termination.
> >>>>> Here, "progress +=3D 1" reflects the actual number of PTEs scanned,=
 but
> >>>>> previously "progress +=3D HPAGE_PMD_NR" always.
> >>>>>
> >>>>> - When the memory has been collapsed to PMD, let me provide a detai=
led
> >>>>>   example:
> >>>>>
> >>>>> The following data is traced by bpftrace on a desktop system. After
> >>>>> the system has been left idle for 10 minutes upon booting, a lot of
> >>>>> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full sca=
n
> >>>>> by khugepaged.
> >>>>>
> >>>>> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> >>>>> @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
> >>>>> @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
> >>>>> @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
> >>>> Could you elaborate what is [1], [6] etc and 1,2,142, etc?
> >>> These 1,6 are value of "enum scan_result", you can directly refer to =
the
> >>> notes on the right.
> >>>
> >>> These 1,2,142,178 are number of different "enum scan_result" from
> >>> trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file.
> >>>
> >>> as example, SCAN_PMD_MAPPED has 142 times during a full scan by
> >>> khugepaged.
> >> Thanks. Can you please mention this in the patch description. You can =
simply
> >> right it like this:
> >>
> >> "From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, =
the
> >> following statuses were observed, with frequency mentioned next to the=
m:
> >>
> >> SCAN_SUCCEED: 1
> >> SCAN_PMD_MAPPED: 142
> >> ....."
> >>
> >> and so on.
> > LGTM, I will do it in the next version. Thanks!
> >
> >>>>> total progress size: 674 MB
> >>>>> Total time         : 419 seconds ## include khugepaged_scan_sleep_m=
illisecs
> >>>>>
> >>>>> The khugepaged_scan list save all task that support collapse into h=
ugepage,
> >>>>> as long as the task is not destroyed, khugepaged will not remove it=
 from
> >>>>> the khugepaged_scan list. This exist a phenomenon where task has al=
ready
> >>>>> collapsed all memory regions into hugepage, but khugepaged continue=
s to
> >>>>> scan it, which wastes CPU time and invalid, and due to
> >>>>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait fo=
r
> >>>>> scanning a large number of invalid task, so scanning really valid t=
ask
> >>>>> is later.
> >>>>>
> >>>>> After applying this patch, when the memory is either SCAN_PMD_MAPPE=
D or
> >>>>> SCAN_NO_PTE_TABLE, just skip it, as follow:
> >>>>>
> >>>>> @scan_pmd_status[6]: 2
> >>>>> @scan_pmd_status[3]: 147
> >>>>> @scan_pmd_status[2]: 173
> >>>>> total progress size: 45 MB
> >>>>> Total time         : 20 seconds
> >>>>>
> >>>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> >>>>> ---
> >>>>>  include/linux/xarray.h |  9 ++++++++
> >>>>>  mm/khugepaged.c        | 47 ++++++++++++++++++++++++++++++++++----=
----
> >>>>>  2 files changed, 47 insertions(+), 9 deletions(-)
> >>>>>
> >>>>> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> >>>>> index be850174e802..f77d97d7b957 100644
> >>>>> --- a/include/linux/xarray.h
> >>>>> +++ b/include/linux/xarray.h
> >>>>> @@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *=
xas, unsigned long index)
> >>>>>   xas->xa_node =3D XAS_RESTART;
> >>>>>  }
> >>>>>
> >>>>> +/**
> >>>>> + * xas_get_index() - Get XArray operation state for a different in=
dex.
> >>>>> + * @xas: XArray operation state.
> >>>>> + */
> >>>>> +static inline unsigned long xas_get_index(struct xa_state *xas)
> >>>>> +{
> >>>>> + return xas->xa_index;
> >>>>> +}
> >>>>> +
> >>>>>  /**
> >>>>>   * xas_advance() - Skip over sibling entries.
> >>>>>   * @xas: XArray operation state.
> >>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>>>> index 6f0f05148765..de95029e3763 100644
> >>>>> --- a/mm/khugepaged.c
> >>>>> +++ b/mm/khugepaged.c
> >>>>> @@ -68,7 +68,10 @@ enum scan_result {
> >>>>>  static struct task_struct *khugepaged_thread __read_mostly;
> >>>>>  static DEFINE_MUTEX(khugepaged_mutex);
> >>>>>
> >>>>> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> >>>>> +/*
> >>>>> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or v=
mas
> >>>>> + * every 10 second.
> >>>>> + */
> >>>>>  static unsigned int khugepaged_pages_to_scan __read_mostly;
> >>>>>  static unsigned int khugepaged_pages_collapsed;
> >>>>>  static unsigned int khugepaged_full_scans;
> >>>>> @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(st=
ruct mm_struct *mm, unsigned long a
> >>>>>  }
> >>>>>
> >>>>>  static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *=
mm,
> >>>>> -         struct vm_area_struct *vma, unsigned long start_addr, boo=
l *mmap_locked,
> >>>>> +         struct vm_area_struct *vma, unsigned long start_addr,
> >>>>> +         bool *mmap_locked, unsigned int *cur_progress,
> >>>>>           struct collapse_control *cc)
> >>>>>  {
> >>>>>   pmd_t *pmd;
> >>>>> @@ -1255,6 +1259,9 @@ static enum scan_result hpage_collapse_scan_p=
md(struct mm_struct *mm,
> >>>>>
> >>>>>   VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >>>>>
> >>>>> + if (cur_progress)
> >>>>> +         *cur_progress +=3D 1;
> >>>> Why not be a little more explicit, and do this addition if find_pmd_=
or_thp_or_none fails,
> >>>> or pte_offset_map_lock fails? The way you do it right now is not rea=
dable - it gives no
> >>>> idea as to why on function entry we do a +1 right away. Please do ad=
d some comments too.
> >>> If this way is not clear enough, we can directly add 1 in
> >>> find_pmd_or_thp_or_none() etc, BUT it's a bit redundant.
> >>> Please take a look at which one is better.
> >>>
> >>> case 1:
> >>> as the V4 PATCH #2 [1] and #3 [2], only hpage_collapse_scan_pmd().
> >>> [1] https://lore.kernel.org/linux-mm/20260111121909.8410-3-yanglinche=
ng@kylinos.cn
> >>> [2] https://lore.kernel.org/linux-mm/20260111121909.8410-4-yanglinche=
ng@kylinos.cn
> >>>
> >>> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >>>             struct vm_area_struct *vma, unsigned long start_addr,
> >>>             bool *mmap_locked, unsigned int *cur_progress,
> >>>             struct collapse_control *cc)
> >>> {
> >>>     ...
> >>>     result =3D find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >>>     if (result !=3D SCAN_SUCCEED) {
> >>>             if (cur_progress)
> >>>                     *cur_progress +=3D 1; // here
> >>>             goto out;
> >>>     }
> >>>     ...
> >>>     pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >>>     if (!pte) {
> >>>             if (cur_progress)
> >>>                     *cur_progress +=3D 1; // here
> >>>             result =3D SCAN_NO_PTE_TABLE;
> >>>             goto out;
> >>>     }
> >>>
> >>>     for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >>>          _pte++, addr +=3D PAGE_SIZE) {
> >>>             if (cur_progress)
> >>>                     *cur_progress +=3D 1; // here
> >>>             ...
> >>>     }
> >>> }
> >>>
> >>> case 2:
> >>>
> >>> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >>>             struct vm_area_struct *vma, unsigned long start_addr,
> >>>             bool *mmap_locked, unsigned int *cur_progress,
> >>>             struct collapse_control *cc)
> >>> {
> >>>     ...
> >>>     result =3D find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >>>     if (result !=3D SCAN_SUCCEED) {
> >>>             if (cur_progress)
> >>>                     *cur_progress +=3D 1; // here
> >> Let us be more explicit and set this equal to 1, instead of adding 1.
> > LGTM, I will do it in the next version. Thanks!
> >
> >>>             goto out;
> >>>     }
> >>>     ...
> >>>     pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >>>     if (!pte) {
> >>>             if (cur_progress)
> >>>                     *cur_progress +=3D 1; // here
> >> Same comment as above.
> >>
> >>>             result =3D SCAN_NO_PTE_TABLE;
> >>>             goto out;
> >>>     }
> >>>
> >>>     for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >>>          _pte++, addr +=3D PAGE_SIZE) {
> >>>             ...
> >>>     }
> >>>     ...
> >>> out_unmap:
> >>>     if (cur_progress) {
> >>>             if (_pte >=3D pte + HPAGE_PMD_NR)
> >>>                     *cur_progress +=3D HPAGE_PMD_NR;   // here
> >>>             else
> >>>                     *cur_progress +=3D _pte - pte + 1; // here
> >>>     }
> >>> }
> >> I will vote case 2. In case 1 I don't like the fact that the if (cur_p=
rogress)
> >> branch will be checked each iteration - and I don't think the compiler=
 can
> >> optimize this since the body of the loop is complex, so this check can=
not
> >> be hoisted out of the loop.
> >>
> >>
> >>> case 3:
> >>>     current patch, and add more comments to clearer.
> >>>
> >>>>> +
> >>>>>   result =3D find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >>>>>   if (result !=3D SCAN_SUCCEED)
> >>>>>           goto out;
> >>>>> @@ -1396,6 +1403,12 @@ static enum scan_result hpage_collapse_scan_=
pmd(struct mm_struct *mm,
> >>>>>           result =3D SCAN_SUCCEED;
> >>>>>   }
> >>>>>  out_unmap:
> >>>>> + if (cur_progress) {
> >>>>> +         if (_pte >=3D pte + HPAGE_PMD_NR)
> >>>>> +                 *cur_progress +=3D HPAGE_PMD_NR - 1;
> >>>>> +         else
> >>>>> +                 *cur_progress +=3D _pte - pte;
> >>>>> + }
> >>>>>   pte_unmap_unlock(pte, ptl);
> >>>>>   if (result =3D=3D SCAN_SUCCEED) {
> >>>>>           result =3D collapse_huge_page(mm, start_addr, referenced,
> >>>>> @@ -2286,8 +2299,9 @@ static enum scan_result collapse_file(struct =
mm_struct *mm, unsigned long addr,
> >>>>>   return result;
> >>>>>  }
> >>>>>
> >>>>> -static enum scan_result hpage_collapse_scan_file(struct mm_struct =
*mm, unsigned long addr,
> >>>>> -         struct file *file, pgoff_t start, struct collapse_control=
 *cc)
> >>>>> +static enum scan_result hpage_collapse_scan_file(struct mm_struct =
*mm,
> >>>>> +         unsigned long addr, struct file *file, pgoff_t start,
> >>>>> +         unsigned int *cur_progress, struct collapse_control *cc)
> >>>>>  {
> >>>>>   struct folio *folio =3D NULL;
> >>>>>   struct address_space *mapping =3D file->f_mapping;
> >>>>> @@ -2376,6 +2390,18 @@ static enum scan_result hpage_collapse_scan_=
file(struct mm_struct *mm, unsigned
> >>>>>                   cond_resched_rcu();
> >>>>>           }
> >>>>>   }
> >>>>> + if (cur_progress) {
> >>>>> +         unsigned long idx =3D xas_get_index(&xas) - start;
> >>>>> +
> >>>>> +         if (folio =3D=3D NULL)
> >>>>> +                 *cur_progress +=3D HPAGE_PMD_NR;
> >>>> I think this whole block needs some comments. Can you explain, why y=
ou
> >>>> do a particular increment in each case?
> >>>>
> >>>>> +         else if (xa_is_value(folio))
> >>>>> +                 *cur_progress +=3D idx + (1 << xas_get_order(&xas=
));
> >>>>> +         else if (folio_order(folio) =3D=3D HPAGE_PMD_ORDER)
> >>>>> +                 *cur_progress +=3D idx + 1;
> >>>>> +         else
> >>>>> +                 *cur_progress +=3D idx + folio_nr_pages(folio);
> >>>>> + }
> >>> The "idx" represent PTEs number already scanned when exiting
> >>> xas_for_each().
> >>>
> >>> However, the last valid folio size was not counted in "idx" (except
> >>> folio =3D=3D NULL, "idx" equal to HPAGE_PMD_NR), which can be further
> >>> divided into three cases:
> >> But, the number of PTEs you account in these three cases, are *not*
> >> scanned, right? So we can simply drop these 3 cases.
> > No, these three cases are the last scanning folio to break, I think we
> > need to add them. Imagine that if we trigger HPAGE_PMD_ORDER folio
> > firstly, "idx" is equal to 0.
>
> If you hit a large folio and break, you don't consume any extra iteration=
s.
> The number of iterations is completely determined by xa_index. This is ki=
nd
> of analogous to SCAN_PMD_MAPPED - in one "iteration", you decide to stop
> scanning, and set progress to 1.
>
> In any case, the problem which you describe in the patch description is
> completely solved by setting progress to 1 upon failure of find_pmd_or_th=
p_or_none.
> So anything else which you do (like counting iterations in hpage_collapse=
_scan_pmd
> or hpage_collapse_scan_file) is extra and it is not clear if it has a pra=
ctical
> benefit. The patch benefits us because there are a lot of SCAN_PMD_MAPPED=
 and SCAN_PMD_NONE.
> Will we practically also encounter a large number of SCAN_EXCEED_PTE_SWAP=
, PTE_NONE, etc?
>
> I tilt towards keeping the other bits of the patch, if they can be simpli=
fied, and
> because this patch is relatively harmless. Just like you count the number=
 of iterations
> in hpage_collapse_scan_pmd(), you can do the same here using xa_index.

The semantics of hpage_collapse_scan_pmd() _pte and hpage_collapse_scan_fil=
e()
xas.xa_index are different.

Let me give a detailed example :)

xas->xa_index represents the starting address of the last folio when exitin=
g
xas_for_each().

Assuming each folio size is 32KB, when we iterate "folio1 -> folio2" and br=
eak,
xas->xa_index equals the starting address of folio2, so "idx =3D 8". Howeve=
r,
folio2 is not counted in "idx".

In reality, folio2 has been scanned, so we need to add the folio2 size, mak=
ing
"idx =3D 16" the correct value.

There are two ways for folio2:
1. shmem swap entries (xa_is_value), breaking out of the xas_for_each loop
   due to SCAN_EXCEED_SWAP_PTE.
2. Normal folio, breaking out of the xas_for_each loop due to
   SCAN_SCAN_ABORT/SCAN_PAGE_LRU/SCAN_PAGE_COUNT.

Move Lance suggestion to here.
> if (cur_progress)
>       *cur_progress =3D max(xas.xa_index - start, 1UL);

If we use the code suggested by Lance, we will miss the folio2 size,
the result is "idx =3D 8".
Is this the result we wanted? If Yes, Lance's suggested code is perfect.

Another more specific scenario is when the first iterated folio is
HPAGE_PMD_ORDER, "idx =3D 0", Yep, we can directly set "cur_progress =3D 1"=
,
it's simple enough.

> >
> >>> 1. shmem swap entries (xa_is_value), add folio size.
> >>> 2. the folio is HPAGE_PMD_ORDER, the memory has been collapsed
> >>>    to PMD, so add 1 only.
> >>> 3. Normal folio, add folio size.
> >>>
> >>> Is the version below more readable?
> >>>
> >>>     if (cur_progress) {
> >>>             *cur_progress +=3D xas.xa_index - start;
> >>>
> >>>             if (folio) {
> >>>                     if (xa_is_value(folio))
> >>>                             *cur_progress +=3D 1 << xas_get_order(&xa=
s);
> >>>                     else if (folio_order(folio) =3D=3D HPAGE_PMD_ORDE=
R)
> >>>                             *cur_progress +=3D 1;
> >>>                     else
> >>>                             *cur_progress +=3D folio_nr_pages(folio);
> >>>             }
> >>>     }
> >> Yep, this is unneeded complexity. This looks really ugly and the benef=
its of
> >> this are not clear. You can simply do
> >>
> >> if (cur_progress)
> >>      *cur_progress =3D xas.xa_index - start;
> >>
> >>>>>   rcu_read_unlock();
> >>>>>
> >>>>>   if (result =3D=3D SCAN_SUCCEED) {
> >>>>> @@ -2456,6 +2482,7 @@ static unsigned int khugepaged_scan_mm_slot(u=
nsigned int pages, enum scan_result
> >>>>>
> >>>>>           while (khugepaged_scan.address < hend) {
> >>>>>                   bool mmap_locked =3D true;
> >>>>> +                 unsigned int cur_progress =3D 0;
> >>>>>
> >>>>>                   cond_resched();
> >>>>>                   if (unlikely(hpage_collapse_test_exit_or_disable(=
mm)))
> >>>>> @@ -2472,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(u=
nsigned int pages, enum scan_result
> >>>>>                           mmap_read_unlock(mm);
> >>>>>                           mmap_locked =3D false;
> >>>>>                           *result =3D hpage_collapse_scan_file(mm,
> >>>>> -                                 khugepaged_scan.address, file, pg=
off, cc);
> >>>>> +                                 khugepaged_scan.address, file, pg=
off,
> >>>>> +                                 &cur_progress, cc);
> >>>>>                           fput(file);
> >>>>>                           if (*result =3D=3D SCAN_PTE_MAPPED_HUGEPA=
GE) {
> >>>>>                                   mmap_read_lock(mm);
> >>>>> @@ -2486,7 +2514,8 @@ static unsigned int khugepaged_scan_mm_slot(u=
nsigned int pages, enum scan_result
> >>>>>                           }
> >>>>>                   } else {
> >>>>>                           *result =3D hpage_collapse_scan_pmd(mm, v=
ma,
> >>>>> -                                 khugepaged_scan.address, &mmap_lo=
cked, cc);
> >>>>> +                                 khugepaged_scan.address, &mmap_lo=
cked,
> >>>>> +                                 &cur_progress, cc);
> >>>>>                   }
> >>>>>
> >>>>>                   if (*result =3D=3D SCAN_SUCCEED)
> >>>>> @@ -2494,7 +2523,7 @@ static unsigned int khugepaged_scan_mm_slot(u=
nsigned int pages, enum scan_result
> >>>>>
> >>>>>                   /* move to next address */
> >>>>>                   khugepaged_scan.address +=3D HPAGE_PMD_SIZE;
> >>>>> -                 progress +=3D HPAGE_PMD_NR;
> >>>>> +                 progress +=3D cur_progress;
> >>>>>                   if (!mmap_locked)
> >>>>>                           /*
> >>>>>                            * We released mmap_lock so break loop.  =
Note
> >>>>> @@ -2817,7 +2846,7 @@ int madvise_collapse(struct vm_area_struct *v=
ma, unsigned long start,
> >>>>>                   mmap_locked =3D false;
> >>>>>                   *lock_dropped =3D true;
> >>>>>                   result =3D hpage_collapse_scan_file(mm, addr, fil=
e, pgoff,
> >>>>> -                                                   cc);
> >>>>> +                                                   NULL, cc);
> >>>>>
> >>>>>                   if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK &&=
 !triggered_wb &&
> >>>>>                       mapping_can_writeback(file->f_mapping)) {
> >>>>> @@ -2832,7 +2861,7 @@ int madvise_collapse(struct vm_area_struct *v=
ma, unsigned long start,
> >>>>>                   fput(file);
> >>>>>           } else {
> >>>>>                   result =3D hpage_collapse_scan_pmd(mm, vma, addr,
> >>>>> -                                                  &mmap_locked, cc=
);
> >>>>> +                                                  &mmap_locked, NU=
LL, cc);
> >>>>>           }
> >>>>>           if (!mmap_locked)
> >>>>>                   *lock_dropped =3D true;
> >>> --
> >>> Thanks,
> >>> Vernon

