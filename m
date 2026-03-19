Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33B751091916
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 22:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9690B6B04DF; Thu, 19 Mar 2026 18:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC586B04E1; Thu, 19 Mar 2026 18:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D0B6B04E3; Thu, 19 Mar 2026 18:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6159A6B04DF
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:09:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 076BA13B95D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:09:51 +0000 (UTC)
X-FDA: 84564205782.18.32BA456
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id EB18640015
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:09:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=B6SysylH;
	spf=pass (imf12.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773958189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svD4wMks8gwyXRL5XOV+qF8B6FaNKoBJNHk7PXgg3Q0=;
	b=oW5BhE61kJvhjlYanXfGOCqDt95btlbaXXZeLkaovufMf8j2W1mOsdgl8uQIbEgX2DkwS0
	KZhTsoDuv5QJ5zdcp5x+ZadO53i+KZsAOxicZG7uoZa4/+thnZs0MhcrWPTvDQ29QD3RSh
	Fok29I9M8q2prCtoZjgS3/OVVKsWyGg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773958189; a=rsa-sha256;
	cv=pass;
	b=MUmcVHIJOTrzmncivIDPyQerxtjRD81e72Mjqhcp/towqbrZo9KUgjEIjpxLSOjXpCEYr3
	fmrrhwTW9r1I7wndO7JweJFsYs716r0b3bK0dR5GmT8RzLFLrLGF52cJXqe7wdBg+JTVr1
	cNBAGxY6AqMCn66CYrgAUVTs5HDr/Wo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=B6SysylH;
	spf=pass (imf12.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5a10d130b37so527839e87.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:09:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773958187; cv=none;
        d=google.com; s=arc-20240605;
        b=fbSEhTtcs1xY6Q4K7iT+EymIaq3u04mKfDllqawHdy/e2tB4mtnAE8teFUu/bBCIMW
         3z4pSl+SeoA4mQvCWVy+sWnk+XJMjeo8UK9IYhnfOMgB7vkUxzy9wtvFluCMxfGKOLGK
         gsa3RylRjvGnvDYu5B9/4/5gM2c+BsmociUS0h2iv+pDtSukEFoE1s1GqbwUj/lk1yNB
         0srKbJ9e4LKokYsUQ9LnHIhz12WQNt550TOCCWbCscNYAMMvU0Qh6xKhX9r9R9ZfIWiL
         OsBDZtO1J+ifdEO4kOQBhFt86PSZgTgF+CHBzg7pwA02l57ImnK+CFktVMZowLtAaTVi
         u3dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=svD4wMks8gwyXRL5XOV+qF8B6FaNKoBJNHk7PXgg3Q0=;
        fh=wR/ZN8jDqSWX+FQmSGgoQ1+RGEBWc6Gzv2vi/UqT+pI=;
        b=i3zpOIqiACo32GV2IgsPuc3ecMmkAqQDpEDT2RzbP5I1O6fNlJJKcAl48pCWioV5e9
         w+ExjaDZmnZDYJP/rlyl3A0gTQPc2sM+VArsVlj4gpBuYQ15cdTG4o/7QWWF3gSTYeOW
         J1VhmseNrElSWlT1PwKBruxeOgnDKqzLLZFHMDsL6Wvps+b6XuFNHitCKUqrC+51JpW5
         RYqSvxoBR2iEA+tFHQplf3WAt/iV7zjNoa724xdV+UvC/h71slkYQbjOV3wJtFtfjviz
         f+gw2d0/iWdu4Y9SF7/+DOxtMcB1x/qfVpPFoJ2kP/Egpvq5WlundViuFOfOO70OX5UO
         +p4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773958187; x=1774562987; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=svD4wMks8gwyXRL5XOV+qF8B6FaNKoBJNHk7PXgg3Q0=;
        b=B6SysylH+NqeUgjtf7OE+ILJjai0CZPBNow3PX6sGkh9wXbcW0wMaVaAGD5fnIhAQN
         zEynwZzyHqG34TFU485wtHzdccvdn6BuCTjcYXL4VyjcS5deh4oteMxlOqzoNgqhPjQI
         5Crv4uLOgmzCGFwOAI4oUXJ/QXCwfZhNJgXJqn2RBJmJxFlycSemmDZige6lbu35EeXL
         pLBBSLrKsg4wsRHRyaqLiAwKTSyBYIZV2tadViak57scu3sc+6xCmvQxZOZU3vbeugY+
         MV52Q8CT5gb/H4yf9gd4N3RQyf0Uicrm52Nytv37XQqGz16TZmNxwvdbU2Ty/sMaFq2t
         PuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773958187; x=1774562987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=svD4wMks8gwyXRL5XOV+qF8B6FaNKoBJNHk7PXgg3Q0=;
        b=JSCL3ERNOBTRv1/BV/DNBiTvmq+uoCY9Imnp5CcQQYhmAAXwzWI84+a25p7ffBamWo
         PSu3PENJs4GVIJOFIta1NIwrNKIuarNiLzMkKlivGqs4deH2nHsNRx35W4CRAV7fjrjW
         C0aiO1NZrEcfIFcMFfLDkhQJ0vuTcwl+C3/KmZ+q2StuEMj2yfFpKLMIRAmaA8Ji70mX
         qlB71rmYP5zQyk3JI/RxAgwG1zTsab5Y77rPGGX2amanW1qwTw4MJB4Dar5u8XK985Tg
         IIDgA0ne3V4mRsQ88Z1VUcQ63flAr7D8ATXN2VI6ajWAfmxaP37vTskUWDX18jbZDHP4
         ia2w==
X-Forwarded-Encrypted: i=1; AJvYcCW17bu18jpI+8zXG9Tp8/fzDbZA5LFa0F+VpbmHm/pqFO51JmJmuZxAX8ssz5kJVlZo7ii79BVD4Q==@kvack.org
X-Gm-Message-State: AOJu0YxA3nlTkQL7XhVjVPoeeXO2IMFlHl2UaXdIjVSLmtKdBzCoC7nc
	hx3xXLLVgmQ2sOJXAciFZSYV7864M07pi+SJbo7PQno5MPp3dGwLMKUBv1mOXgpcUO+o/bY6HLO
	EQDWjuJz1TNpKX6dXOGMgdgMA8FABEvAoSaNuUbo7
X-Gm-Gg: ATEYQzxy3w2TuJG4ZzCFYbuBuk+7voLpKlAO2eZ7ORUU6mgeOuNOdZv4ZDoJeu7oD99
	Py7T53S7Im41QtlYQOG3EavObzVmPC+v6K5260hDGe09cL5q8/oK3U8kb1bqFycco962mZRcTeB
	VmuwDJc9F4Dw8ASG/ZdJolt8UGOum8Gj/ZIAdYmGMm3ygp/L/6Q9wbgQTDmuf/hP11hRLsMiK8k
	umc2/o6rjMa4O+OWalfQ5mHSu2fIJHyPYed2Eqkds2BykM2Cx/e3nXxCKAyDsqZgpJqCeEA5J8/
	Jj7NNwEY
X-Received: by 2002:a05:6512:3b22:b0:5a1:742d:277f with SMTP id
 2adb3069b0e04-5a27de01545mr1986403e87.11.1773958186394; Thu, 19 Mar 2026
 15:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-5-dmatlack@google.com>
 <20260225143328.35be89f6@shazbot.org> <aZ-CnywNgMnr6f1k@google.com> <CAAywjhR4Azqx8hXRap0eLUrwetYRiX8TALEM=b+1BorPc3eJdQ@mail.gmail.com>
In-Reply-To: <CAAywjhR4Azqx8hXRap0eLUrwetYRiX8TALEM=b+1BorPc3eJdQ@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 19 Mar 2026 15:09:18 -0700
X-Gm-Features: AaiRm51momKlFVcCV9Yk7taG4PZCOSiNfgaYNzeVE1MwV2qirg6S-TkURRRSfl8
Message-ID: <CALzav=cMEkenGKYvA=rNmTmVjpf_DW_92MCFx-2gxqKbrdG0Kg@mail.gmail.com>
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EB18640015
X-Stat-Signature: cc9bjkhweiehamfkew8dqkgmopezjr7n
X-Rspam-User: 
X-HE-Tag: 1773958188-631997
X-HE-Meta: U2FsdGVkX19jq25gt82vEiCfzhvjD2UG67I/EJQYs+6mhy3pXIoVuGjvF97oeFoXLbhAfpzvv5CEYRb1BjzgJT9tkOUf4l7qL5eu3hOim+lvjSvjXh1IJGq+Dc3f9vCAjcjmYFbffAjax4tJ+RR/W2nL9YoZwV9pmWoAjUPjxL1mPQ+Nh3LbWA0ZvEgHMR7tZA6hbT90wLIcSxicl/cW2ZByLh1NLb3szDXel2tpw2GU3S1q/EVbUEONSP2z4ic/+6ZFW2lM5joPM6AKdMgoeAKdOiz9H+r7IGBtgnWyrzjjqj7Bt2dG/ml070J5m5CfNjwrOaSVqwWG8Kwe/jW4LrXtvnWz78z77RqNOHRCL4ZzuwnEz0K3AgR3xgosl16s99z66928sGuPuKU6sC5wWjPLKBxJpUy2q+z4fAmyVnCLnaJnaEmCQeo3mjgRLGZyRkYRduEHHhjrc6mYZShe8HNla3s5TqFJZXlJvw9CxYMCnnqMjE1Lctfft/H3LyYsXqhtuMQ3h24iLDvnESlGtgxZWiKlkcct0TQYnspn7oEwVcYTeYiKo7bKsF6p42s2rRMjF292GrjPErHPSb8hbvcH6E4T8JIy9XASCo52aO4xcly5nurDslGMsV0W/O/WvQhItM7co/1rsUexbnI4dR+SIeypdyY4wtlLA0EfFYc9BDeUREoeP8KfFmwWEKIdaBDS4ztxbQQ5yPtMWUOUBaH11XoUHffX7g9jxzuYqdu+0X2GAoRzacQ3PRkxJ55wHTPjvWz8m+D9hDpZOmCQjAvxlghb58LHRv1f21bNJ2rqDmEhPQGp+mHuGkuG/Rg3rMwKk3JWRgl9gemzqPcoEYiAsryt/9y/d6ryu7FUXLG/Vom1q0ZfsdOszrwIN5HexeHUDvDrTyGmqzwaF1jKd/QEfLya5d+oLtAwIYPAElnMo7fbXgmU4pEtVW951Czz7sJmLQcsAtPrXwMqlsO
 MUdRsMPy
 nVRKMDOakC/yXUJQk+YbX9myMXdLRd8MV49ZHpTc3mWGt0QIDePyv7Z1LrSSBaTEZIX5T3rTxF+Bx4VStd29cCki0xgSrAFChJV2szxO2RQyq/LICqpSjn7HJu7FIk+g30iz4lZnZf69TCuRKaUvm9GWK5ZmX/ZOAF+X2/FBdaKYV9K3dGSgH1TbJPEVx5OSUxZgzm9ejgTTMAruNqQLg3s5QWKfdgGTJlZMX2WIi9TEtc4oNBI5WCq19CuoduFh+GfB0KfluVK+nHV+dPusdrjdkAGnf3ZaoX4W0e5DLybitS/miJWqe+VAhZ3fTrWKeqEnhCunCYnNf9/HIU/837MetFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 3:55=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> On Wed, Feb 25, 2026 at 3:15=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On 2026-02-25 02:33 PM, Alex Williamson wrote:
> > > On Thu, 29 Jan 2026 21:24:51 +0000
> > > David Matlack <dmatlack@google.com> wrote:
> >
> > > > +int __init vfio_pci_liveupdate_init(void)
> > > > +{
> > > > +   if (!liveupdate_enabled())
> > > > +           return 0;
> > > > +
> > > > +   return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh=
);
> > > > +}
> > >
> > > liveupdate_register_file_handler() "pins" vfio-pci with a
> > > try_module_get().  Since this is done in our module_init function and
> > > unregister occurs in our module_exit function, rather than relative
> > > to any actual device binding or usage, this means vfio-pci CANNOT be
> > > unloaded.  That seems bad.  Thanks,
> >
> > Good point. So a better approach that would allow vfio-pci to be
> > unloaded would be to register the file handler when the number of
> > devices bound to vfio-pci goes from 0->1 and then unregister on 1->0.
>
> Yeah maybe a kref that gets inc/dec in probe/remove. I have a similar
> problem with iommufd preservation, but I think I can handle it based
> on the number of iommufd open.
>
> I am wondering whether this file handler registration kref stuff can
> be moved into LUO by adding it to LUO file_handler and the modules
> only call get/put?

Circling back here, the new plan is for LUO to not take a module
reference in liveupdate_register_file_handler():

  https://lore.kernel.org/lkml/20260318141637.1870220-13-pasha.tatashin@sol=
een.com/

In the next version of this series I am going to rebase on top of
Pasha's changes and keep the call to
liveupdate_register_file_handler() where it is.

