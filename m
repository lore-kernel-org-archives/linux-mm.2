Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9510C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 23:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91AF06B0005; Mon, 13 Jul 2026 19:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE9D6B0088; Mon, 13 Jul 2026 19:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795D46B008A; Mon, 13 Jul 2026 19:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 424D66B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:51:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6E5F120201
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:51:14 +0000 (UTC)
X-FDA: 84985402068.30.17D44F6
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id B9D48140005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:51:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vkSKXezc;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783986672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivaQUJu/mRyfMnuwfBNsGTkWkGDvNgiNwDOd9icGQ3M=;
	b=iABRjT60zHcfdKrLRlh/6MFUdXwlWQjiZqSLsb21xEopcS4960g3qgXfovMhNDEkPXdarv
	+YEVVE4u2nPYPrVdZphpMK0z9sCQJX0O6vdzO+xWN8HUFD1GK4v/nzj03lE77GNvWvgY0H
	j3TD05i+263897Xw0pl81qJt+C0smLw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vkSKXezc;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783986672;
	b=3GRVoqz8/eMSuVgZCjhL7cPoDNW299tpbiAzJKM3kcQR/0WAZD/IO9nlWmqcuJXG7Pos7U
	cIpSKlz3DkkmJbCENaFWkqNZCfbLOmyaZ4Ku6wCnGXPcNEFndyX+oSvjNkPP0IL+o5KxN4
	zts7HJK9CusKZXBXsZExLp+3xHwqu3U=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2caced6038eso5394415ad.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:51:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783986672; cv=none;
        d=google.com; s=arc-20260327;
        b=UzBTiVMeLAq6QhivI+NyIJnhCsLFsL+wEBFEE5Kwk3pchYjwTpB4CtC/Qomdr100RK
         jvxvfi2OOLTmbsIMQBoWTG4syf4dhgcgSvVq8IbwSqOVYzDTOrJv+mkEkFV+1pM45wk1
         9ffSlJHgrfTl+qqqkB/Hz5JTJKSk/V7KQXoi0vh1cspAT+emWTGve2U92WNWvjmNF/VZ
         EH7NIgsxR08zZ2+IUnQpt7hmG79BQOWdLv8tJ/TRmdq7eUJwdOPnGIKzP25Nr/y8MlSG
         tu+QqBtDb7B8KeanN2yy0lcUwk52d+8gcW37jdSiAPVGq3tOHzLCcKV9po9H0GSl9yk4
         9+/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ivaQUJu/mRyfMnuwfBNsGTkWkGDvNgiNwDOd9icGQ3M=;
        fh=Jx2QIz9jO1XWZnr7VhhWp0SQzLv4gQLNXXfQyhn1vZk=;
        b=JstXL6+M69nkuXZr9OHpLO43cXmF5cDIrWTIJEmg556nhvQhf+f/9QFb2j8eRhmStM
         fFjmOgCGTp4D9UBFjY4TVfQaOngejcyBzU8QZevl86gSEYLbUI3oR9U3ToDvAx7y/D7L
         iy0vdEcC6JF1poCMn8zbLQwuhtg7InQPvz1e1ENvMD4lS/cugcxs9zYfv0DR7SedXVw1
         aSs0hVwBir5f/AeSJO/knQ+Zl01nANIM68Fuv97WASOmkY4LZfswGPY8pQHt8ROAyhAx
         fhdg2mB8/OokM7FaYDNY4cZ0xWzNTIxtaw2XekxJgKUh/MXuAQxYev0OqYT/NWtBeOT2
         2B+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783986672; x=1784591472; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ivaQUJu/mRyfMnuwfBNsGTkWkGDvNgiNwDOd9icGQ3M=;
        b=vkSKXezcEPrJBI+yJ5qZY5gE3ATQpHcYDsHHRlJiuk8mQVnt3YuwwBmZJAOWoAv1Hm
         6P3dvFsJbo6XOxRIYQQuay1R/pRJsK6QYxDd7+J1PA2UD9RUICAo6pxEgWn5xVh+y8Pg
         7fUt/+Nmuaf1d7N/xrAOyNR0FDjPYgd/up7uY44lAB0vqx6UHyVUF/tGbHo0tLYcopST
         1v2kuTXzuxdBGrXFU6ankyhzpcxd4O8tAwARtEGWIAChaFyrKxuwn8hXsMHGNP5Syot0
         HEHWD8PKjyjD/kz+EcJpm2WLDFQexLx2PCqBHWaXtUK/Z3SBj5FuxhTwjscu94MEeb3O
         0qAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783986672; x=1784591472;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ivaQUJu/mRyfMnuwfBNsGTkWkGDvNgiNwDOd9icGQ3M=;
        b=cY6ro3/10Y5e98xU2uXy7N1Jvg2jSL4QZ/vyvHndhXVjK19IRjwp+hN16Sqm+5wmcM
         3qFWUWfUv8CRBBYh0fFSeUEL4u5GZc0YIWm1ixcqz8EGeSr0/0UJofi0efyBPa9Noe0C
         HKEdLfV5kSZrS5d7Z9lRedBkblrP9x5iLWUglgwVjJ+oSDdA4ny7qvVvpkDfKxhYYpYk
         mnKa05pFIXuJBPYrHW2NdVyuDC/cvcTOhuFBSfkv5FiuLrMCM2GfTaeKv4Vj5Ae+8+1x
         KO8FLxXvG7ix/8Al2Cs9D+p2swDRMXi9CwTYckR21lk29dt17cxj9dyU2mpTGVZc35Hn
         20bg==
X-Forwarded-Encrypted: i=1; AHgh+RrKtrXV2U3UL/eMBiG/O/sXu7nat/GOSheHRF8ZpgPdLjxvQ2UIJm2m8ZLeW8WB5bx2kojCS6gnNA==@kvack.org
X-Gm-Message-State: AOJu0Yw/2CH3arZoTYc64Vt91JcjpPnYz8nbgkQciXIrCSdPXYm35D+h
	3wU0lLfWeHuHPMowh/9QqwUBuypaM7ccgTFMwbET7Od8B/dkSt9nOxsuEr226g6pWhGhj5cWJi/
	6LeKvZz/1vbPCNGplbnjLtInOxYZmW6om/xpmClNp
X-Gm-Gg: AfdE7clfZS5x+P3jwm8D2ESAXVLmYFbmQPROzVFkAZshiR80px4Gb/8DtLZoYk1nzTp
	lh8WsG9T6QmY325yuVS1quyR45Qc6TOavr3Pzz3JKivbaUXrx6keoE0ZM3+03pUUlW3X8L+GMAj
	b6jDvdSihcDN9yfw2YWDI3SJHdPvtDVccO068hz+QDHg1L3N3FIQjaCXhDZnXqQJadIGn/3IA3e
	Q+HtLktWjbAU6RMUHpc4b77EANbGOLgiHhNRL2H5T2kuy3RD9R9BbhbAizbPzGewGEc1qTc
X-Received: by 2002:a17:903:4b2b:b0:2cc:db7a:251 with SMTP id
 d9443c01a7336-2ce8285a73bmr140395465ad.2.1783986671057; Mon, 13 Jul 2026
 16:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260702174033.32116-1-sakacpav@amazon.de> <2026071004-strum-perkiness-5d9b@gregkh>
In-Reply-To: <2026071004-strum-perkiness-5d9b@gregkh>
From: David Matlack <dmatlack@google.com>
Date: Mon, 13 Jul 2026 16:50:44 -0700
X-Gm-Features: AVVi8CcmTY0c0Vp441sR3RbEM49xvL1OMRcgoloehgq4aoKMDkzxTiu2LMLBmtw
Message-ID: <CALzav=eCzxZ5980kazjSUDFn1d4Dz+cWbyZyg-MVMca9jntn4Q@mail.gmail.com>
Subject: Re: [RFC PATCH 00/14] driver core: defer per-VF sysfs creation for
 fast SR-IOV bring-up
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavol Sakac <sakacpav@amazon.de>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, 
	driver-core@lists.linux.dev, David Woodhouse <dwmw@amazon.co.uk>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Samiullah Khawaja <skhawaja@google.com>, 
	Alexander Graf <graf@amazon.com>, linux-mm@kvack.org, kexec@lists.infradead.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B9D48140005
X-Stat-Signature: j18yfmtzsmy8wgxemwk79e8c9gtfejua
X-Rspam-User: 
X-HE-Tag: 1783986672-314550
X-HE-Meta: U2FsdGVkX1/dCrfwZ9kX8o6FcmaHZ3xeffF1CoMedJkMCjp2mAnFW+S3NalX2fp9DmzHUIrfE+uzBOjSyhFe3SU3vWiyBRAnjAktlVKaZ+pjNr6cU/LUuImcjUvt7zwzlZPPuUAc+bHFpYqQWfRE7HaWUdTnUiOTWOJgtBKLXn4Qjbf+UDPh0DGJm/VKgawpE/vS+3XG/a9Bj6II8X+JDbEU/YVtYSCBXL2VqkoCIgLfCZSjwx+2UjOTHUrIl4GKuxeduUhxJF/P+j7zb5G21VoEhHXJ26oKT4m+27SYhrDFFcra5vJ0K4yMkcQ7N00xW/b0XbLfV6s5M25DX38o44xPG3Q2U9AVlSt6S6kS/FMPyZjfWds48lQ5Eu2RfPZz5FQwn0qN4q4WlzLTD3TjpJSxpzXdk96dxGHkp41LpUT6bbhpMNZwv4K/SBWWG1j2rMDq+6xWaYa2+NLV7PusfrSnuHyfbaidIUZJ3NJX2nXnsIBP/NrZYtgBsRyxMXxuUvYqZrwPiMlgmbkvp3fsZkluLYrlMn+0ixsy5gOazqzae7lCsV+36Rf9G6YqhBhz+qcAOrkOhFfuTy27SaWh3kpKIgy/8XNDRvO90fjXn1p+6gfxx249KQW0BnvsmJ6L6UXeRzSV/GQ4o9DHtGHzu5tgd43DAKQw7QmmG86b3cPDBFu1vk7nw4QmSTyDCtpvJ2lOCjMmMayFrypww8Iud1NyWtVqyXAisGKUrBHgdbfxyH5Gy2nV5Kx0HUPi8W7rphvGnX1Ot+XX7nruu9EiKbDv818vV0cFs/ZWLCRssDDEMzh3DRkaLRu1/G3lPCmKNqDrWc3zPVgz5CpKwIMEbUsjdwKN62qUje5XpDRxsql+ZOJm/wlHrvQQwkTY6iKaMFQnv//xvARhP3MkTs5YHxgkNnba201GdkbSoabqoriHGr2iHjS3A5BdCDPpb9M37unXE9QxI7fNp5jInG5
 s5hq7+Fo
 GPIMPCMQoKuvEJ7gSb4I6S+MZhxNdUiglKuUhgFxuOTJqTD9E2zD0/a70EfMR1kK1mD3KYbIFxwTJ3j4q3uUyoIk5XF7SseLON5WRRvrdwALCxDMhOpM3Q5zssfnllIETVpmXVkw8m9fQQZNxFKXgOtoRXe/Ndk9kcfBXykviQDrnq8fgC+Wk5/n43HQNCQaE+ypteTi6S8cGaMqYqVsZjSl9lwzj7o6X0wTsyf4rZeMgWWnAIDL3vfR0I1fOghj7C3ICFW2AeBhpg98/jK912edTr0CNjEGjNEkwo0O+m5drCRA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 7:16=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jul 02, 2026 at 07:40:19PM +0200, Pavol Sakac wrote:
> > Virtualization hardware keeps increasing in CPU-core and VF density.
> > Kernel is trending towards preserving VFs using LUO across a kexec
> > which will put SR-IOV in live-update hotpath. VFs must be re-added to
> > the sysfs tree, along with its supporting devices (e.g. vfio,
> > iommu_groups). On production hardware a single VF can consume ~80 kernf=
s
> > nodes. With thousands of VFs on modern hardware, hundreds of thousands
> > of kernfs nodes need to be created, which can add 100ms+ to the boot
> > time and to guest downtime.
>
> Hundreds of thousands?  You have a hundred sysfs files per device?
>
> > Proposed here is a PoC of deferred materialization of sysfs files until
> > first access to avoid cost of kernfs node creation in hot path. In the
> > reproducer below using a synthetic VF to isolate the sysfs overhead,
> > the per-device sysfs-creation time is reduced by ~74%. It exploits the
> > expected access pattern of hypervisors, where only a subset of device
> > files need to be accessed to attach a VF to a VM on the hot path.
>
> Ick, that access pattern could change with other users, this feels very
> fragile.
>
> > To allow lazy init scheme, a minimal set of files and directories is
> > built per device: a device directory resolves directly to the device's
> > kobject and is used to materialize attributes at access time. The
> > access is trapped in kernfs at the dir-read or path-walk stage and
> > depending on the trigger, either the full directory or a single file is
> > materialized.
> >
> > The changes are two logically distinct parts:
> >
> >   1. Refactor of hardcoded device_add / iommu_group sysfs attribute
> >      creation to a table-driven form to allow walkability of all
> >      attributes and single point of definition for attributes
> >      regardless of lazy opt-in to avoid duplicate definitions and
> >      associated maintainability issues with it.
>
> This is probably a good idea anyway.  Want to just send this as a series
> to start with, so we can take that?
>
> >   2. Lazy-init infra to front-run access to device files at lookup/
> >      readdir time to trigger materialization. Opt-in per device: PCI VF=
s
> >      and VFIO devices opt in via device_set_sysfs_lazy(); iommu_group
> >      opts in at the kobject level.
>
> This is going to get complex.  Where exactly is the bottleneck?  I'm
> guessing that systems with that many devices also have many hundreds of
> CPUs, right?  Are we hitting a single lock somewhere?  There have been
> changes in kernfs in the past to split up the locks to be more
> fine-grained, perhaps that needs to continue to solve this?

+1 I also am wondering if the time can be eliminated entirely instead
of deferred.

It would be nice to have a section of the cover letter that explains
where the time is being spent and why lazy initialization was chosen
over alternative approaches.

>
> > As a PoC, the code does not yet follow this logical structure in the
> > commit sequence and likely does not yet cover all corner cases.
> >
> > Synthetic reproducer measurements
> > ---------------------------------
> >   devices   per-dev time   total time       kernfs nodes (base -> lazy)
> >   -------   ------------   --------------   ---------------------------=
-
> >      500    31.8->8.3 us    15.9-> 4.1 ms     36,417 ->  3,922  (72.8->=
7.8/dev)
> >     1000    33.2->8.7 us    33.2-> 8.7 ms     73,427 ->  8,432  (73.4->=
8.4/dev)
> >     2500    32.8->9.1 us    82.0->22.7 ms    184,421 -> 21,925  (73.8->=
8.8/dev)
> >     5000    33.0->8.7 us   165.1->43.5 ms    369,401 -> 44,406  (73.9->=
8.9/dev)
> >
> > The reproducer is synthetic: an in-kernel module registers N unbound
> > platform devices (60 attributes / 4 groups, ~74 kernfs nodes each; no
> > config space, BARs, or probe) in one timed burst that models SR-IOV
> > enablement. It runs as a two-kernel A/B from one vanilla 7.1-rc2 tree
> > (eager baseline vs patched, plus a patched/opt-in-OFF arm), 20 runs per
> > point. Measures only sysfs-creation slice.
>
> I sure hope sr-iov devices are NOT platform devices.  If so, please go
> fix that up first :)
>
> > Deferral removes ~74% of the sysfs-creation time and ~88% of the kernfs
> > nodes. At 5000 devices that is 121.6 ms removed (165.1 -> 43.5 ms) and
> > ~325,000 fewer kernfs nodes (369,401 -> 44,406). The table-driven rewor=
k
> > adds a +7..+11% eager-path time overhead to non-opted devices.
>
> You're just deferring this work to happen later, so when is that
> "later"?  And what about multi-threaded probing of the bus, doesn't that
> speed stuff up too?
>
> > Available as a docker image that orchestrates builds in qemu guest and
> > prints results as a table (x86_64 Linux host with /dev/kvm assumed):
> >
> >    docker run --device /dev/kvm ghcr.io/pavsa/linux-lazy-sysfs-vf-bench=
:7.1-rc2
> >
> > Assumptions / Trade-offs
> > ------------------------
> > The saving depends on the access pattern of hypervisors, and on no
> > component walking the whole device tree on the hot path to avoid full
> > materialization. Both are expected to hold on optimized hypervisors.
>
> Hah, as if.  Many userspace tools, once a device is notified, walk the
> whole tree of it to read the attributes.  You are going to be fighting
> that problem constantly...

This series could still benefit Live Update scenarios where the
initial userspace stack is small and tightly controlled to resume VMs
as quickly as possible after kexec-ing into the new kernel. It enables
userspace to decide when to incur the cost of creating these files (or
never create them).

But I agree that eliminating the time entirely would be better.

>
> > An actual production hypervisor was observed in local testing to
> > materialize an additional 5-10% of total nodes on average on the hot
> > path.
> >
> > Overhead: +7..+11% eager-path time overhead applies to every non-opted
> > device going through device_add() as all struct devices traverse the
> > walker and can't be gated under a config option.
> > The lazy opt-in infra can be gated under config option to have zero
> > impact if disabled.
>
> Again, where exactly is the time being spent?  What lock is "hot"?
>
> > Final words
> > -----------
> > This is an RFC to first get feedback on the decisions taken at driver
> > core + kernfs level before engaging maintainers of other subsystems
> > if we want to pursue this further or pivot to something else.
> >
> > The code is at a proof-of-concept quality written with AI assistance
> > with some known limitations with main target to gather potential
> > savings and initiate conversation.
> >
> > Feedback appreciated for:
> > - table-driven attribute refactor targeting common device add path /
> >   suggestions for more efficient/less invasive approach
>
> What's wrong with the normal way attributes are defined and allocated?
> They should all be tables today, and the driver core creating them when
> needed, no individual driver should ever be doing that on its own.
>
> thanks,
>
> greg k-h

