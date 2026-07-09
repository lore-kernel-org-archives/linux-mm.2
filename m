Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 861F9C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D7E6B009B; Thu,  9 Jul 2026 11:03:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74ECF6B00A2; Thu,  9 Jul 2026 11:03:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63DCF6B00AC; Thu,  9 Jul 2026 11:03:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 354AA6B009B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:03:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5F7D168B78
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:03:50 +0000 (UTC)
X-FDA: 84969557820.29.1A688E7
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 023F2C002A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:02:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OfPyl3xh;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783609347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RdnglpUnnAqtjCVM1uDDgn3DSuviUHWvWM6L5ZEdJ9w=;
	b=4eZ6tbk9RkNixaliKjLeQZbZtFtz37ibr1Xn1KO9ekblvitxQZg7TtAnBzkHy0NLFbTcsx
	J7PQK5qUbAcx8DHORIy3kDqmfRcb7ZB2Fj+SXZmeIIx78OV7PGwIM8einqT9L7gYtRlAp9
	IjwQYAx00NB4fDt46/9/D2pS2aH6Jec=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OfPyl3xh;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783609347;
	b=qLOrI/qRRnUYhyB8zx1WyhhGLnGuVrU7l63Qr9zZCCPXs+0EKkXHWUIqsEuGrur3CgObkB
	FIO9+YSwrzhkbqs3SO/ltb6iwsEgy2T5/5CHkNJu3uI6VbCatnM9Ohtgmkeupr17Ievnah
	FAvhgHYkGvzTnK3drlMpYkPFusuErk4=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c2a818fc4so13616861cf.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783609346; x=1784214146; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RdnglpUnnAqtjCVM1uDDgn3DSuviUHWvWM6L5ZEdJ9w=;
        b=OfPyl3xhsIjdCvxNsg5CGtjFCRv2vLlQKFsOEVyxOpqtxM51xVs4Saz66+lW37W2mr
         Uy43iDzdRLsiF9Pnw4vb/w9BLh6eosdM4T460JM0r8oF0l1klIy0TNhMYnNOCWVpHXZr
         b5aOneCv/J/S1EKMDA5BNJETMQ3x8FKWu5KRFjJS5YM9wP+5oDTJFK6EhgEYd/hJM1DA
         t46RY+uJtRmPbAu46fm3TXTB5odb4I3XnTCI+4EwKbGMAP8e5MjIlnGDj8StdzVyq3fj
         lw9D9LAGRs6sLGZHh4iBxMtI+FAUZmD3Mh2bpQpJt4kqUAPz+PREKByUyN2+tDYVzWFR
         58PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783609346; x=1784214146;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RdnglpUnnAqtjCVM1uDDgn3DSuviUHWvWM6L5ZEdJ9w=;
        b=A9FpwnM8v5/Z8QmsVCAGL8zQl+3WZq4j9JRZTL64b4tj8bJeUsr2vohwaPt2Ji7AVU
         ElKn0y3p/ZO7A1ZR16Zft5QI0yzH9WI7shhwTJOg5Krp1BklTCn/GRtZ0u+VxW+zylb1
         5Ndf9SI+hUJnIPDRz5U2r8k1l45p3iF5+kRu/CPRzI4HFIaj+aDuoBVkPwSACH8SSb9E
         nXkQox6o+2+pohf4yWG61tb2ledr226g7Brwjqf17TutXxPkLF2DN76CfwkrSjxaJE/n
         LrjXwLlPu5mBMP0I2Tkt3P8cRSXM21V4wuoAS90Cr0NMS9occKBp4gvtUxY8kJvaRik1
         090w==
X-Gm-Message-State: AOJu0Yzji60x1v9843wjyE6yCi46c/+BT4ylY/pG6XUG9tvqPkYbnbqM
	yRZICxZFamhlpi0erEhh7bcDOn3sLlCqN7ZaHop9phJwRG4ERGCRHVLKUI207eIDXZw=
X-Gm-Gg: AfdE7cl92TEXe7KNInyhsupJ7ZRdrTF3jlOq40098WUyRWGrO3uL4eWoUoKxU8KdfnL
	sDZ9YCimoZA4dh0CwUo/DVGwFj1yCA/FZ5sgYyUAgBMwaMyJ3TV3nV7DZu7ssMUYRRbeSw99n7p
	YTVBnvmjP73Yy0GOEjIG7RsImvfVtZsAoDfUtkoL74KZRaSTTswh0QlfBT3C+shxL7siUp8aTRC
	SUhtUj23YwS1uKRdSgHcV1ID7CnO/tkbC/ZZ9YPiJ2DZOo0pNIyYmGG3AVJ3ZUbGJ7ooOibxFEP
	MoqYhNQO3RpUxchjKQJYbnni+24XbBR/AaVARPe8IYzH4JezP80b3GIFCqeM/lujkTv0j6GlEJX
	VBmYeJBPBcsRsRcg/j/UvBhUu7HBAyQSPhi8/ml8tQWsgUiDyvbGVfyCSyqzFISE20wd5DtvMEu
	NitJjqHJLRImCLS/aY3ZX0r987BBGGaYU1twCVer/fbPSugbVxzynwl1RUou5cduw/Buimuu0M+
	Opf7W4=
X-Received: by 2002:ac8:5ccb:0:b0:51c:52a:8e70 with SMTP id d75a77b69052e-51c8b400931mr88109581cf.2.1783609345738;
        Thu, 09 Jul 2026 08:02:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c41dad192sm173838841cf.23.2026.07.09.08.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:02:23 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:02:19 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 10/10] selftests/dax: add dax/kmem hotplug sysfs
 regression test
Message-ID: <ak-3-0OZt09mfeWp@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-11-gourry@gourry.net>
 <ak9Y1UTTe3Hl6rVN@MWDK4CY14F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9Y1UTTe3Hl6rVN@MWDK4CY14F>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 023F2C002A
X-Stat-Signature: pw98fsjsiraj33setj3fq3eztkiruxwo
X-HE-Tag: 1783609346-183425
X-HE-Meta: U2FsdGVkX1++75QXzIY/df6xReLs+zc+j4ecqUbZ0E4i065INMRLiAa5wr0GpF9JMF0O2tMqRbAj82X3XVPvtlXS3TXCAcbsBviOonL0vxYX92GPxDmzJvxvt/d6Hpj93YfIfMs0/f/vSyQuBHBMEgIKwePrCJZ8kbwZGZO6YDjuiIc+/N1c1EIjeR/gNzOgH4ssr4qcOkJxyHkTa/rnYpQl4kloWTTw9oti+3NE1DyIYOis/Nddh0jZTLDt2r2l3MejUsv6NjTIo/1H4HbU5jBLunbp/nnfoqKBQ/58lsb29DJkrAhrehzteylwNciXuHHJNhEV3PZfXP7ITJHSAXfoZJeYkH14ZrKRwdkHWt29hs5ntfUP/m/eLVqggpId2ZN9udFVGAJCr0xiVWrz1n1vQtskFSpOId6/h2pF4s8Sfsj3HaKoVjS8A6XuxIrghFbmUmrrWVYLpEFgu9CCsfmtAy22H8WtlaSfGLAMQj1uZcdSkcRx/7loERRMEiJjJzlWRWTJytaa4iIXWJHxIFGnP2suqznY8U3au6LgUudDV81sBQByAsjOiosilW8lX+3x3RLW8jcROtKLrrD7EsBAEaAMeUmj7Z8wY8eRnKDwMMJiiuCIzz4SStLilozleVpF1Ij5MNftMmRtXwtoRYA2VJnt6fcdD8lU3Z+EeihxY+lvOrNunJMG4RiJJiC31MaMyO7QgSD6Ff8osXk2koIkdNRuWC+D2UUu+jMSRUtftSd1O0H9bkQsTT+VppxjL4+VNqr7n0d/R+h47rNsPvd60pkCmJR2uMlS25ErapRIf1FtFA/6+pHartx35XcczMT8dWOIVPebNs8TugsddJulTuq1KCA0+1LG0ZOgRuEXCuDpangLd206rSL4n/b6GyuC74CS7ork6TCgeTAvLAQgW4wwZC2JZF27uojGBBzV2Im3yzXSrKbKUFp0l9miKOhh9aK9C9za+JOB7Yh
 K/MO8jlk
 tezvtzkzCzCNW0lvjPfrsQCNODijaZOwx2ECp53qzlcnSvY6r+XmxjSDBA+ZfM8Ll3e/1kbWU1ZfL+psky8UKQVoDdBi1TiY1q9WkQM+/zoKOo9T/nvP4SN5WwmvspOdHOJ7Ng6WGEa3uuinl+Wt6YkpEvtfHD9AAYm44A1mR1DHLIoYZzYwrfk9uy0EMQ0f7otGZGMfOuLihRsjhD/PSEYViGeLgbGSFkzZu2F4K+GMQaxZOTOLm26/uR0AptiJJbSdgXZ0mBHxIsnwSVXK/t8Lzdrt7IbqtwL9h6CDXRZg8Q5ufblyfwcRaErpdkXI0nGXHjP8IPaChDeCX59NTSPlrN6DwHPyid0WmDeM6ZiDhc5XWc1QIr40ZlOAyg1taug2650mp+Pw53dlo0crwlTnd5QwFZbm9g7XXNSjvd4ahzJ5FYZCDpy3V0ObgZELHPX0Y2y5RxyrC3fukDGlvXNEKig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 04:20:00PM +0800, Richard Cheng wrote:
> On Tue, Jun 30, 2026 at 05:18:42PM +0800, Gregory Price wrote:
> > Add a kselftest for the dax/kmem whole-device "state" sysfs attribute
> > (/sys/bus/dax/devices/daxX.Y/state), which transitions a kmem-backed
> > dax device between "unplugged", "online" and "online_movable".
> > 
> > The kselftest also includes a test to demonstrate the force-unbind
> > does not deadlock - but this is a destructive test.  The dax device
> > can never be rebound after doing this.
> > 
> > Provisioning a devdax device and binding it to kmem needs daxctl/ndctl
> > out of scope for an in-tree selftest, so the test discovers an already
> > kmem-bound dax device and SKIPs when none are present or the memory
> > cannot be freed to reach a known baseline.
> > 
> > When a device is available it validates the interface contract:
> >   - online / online_movable actually add memory (MemTotal grows),
> >   - online is idempotent,
> >   - switching between online types without unplug is rejected,
> >   - unplug removes memory and the reported state is "unplugged"
> >   - invalid input is rejected.
> > 
> > One specific regression test:
> >     online -> unplug -> online_movable -> unplug
> > 
> > Re-online must re-reserve per-range resources so subsequent unplug
> > actually offlines and removes instead of silently reporting success
> > while the memory stays online.
> > 
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> > ---
> >  tools/testing/selftests/Makefile              |   1 +
> >  tools/testing/selftests/dax/Makefile          |   6 +
> >  tools/testing/selftests/dax/config            |   4 +
> >  .../testing/selftests/dax/dax-kmem-hotplug.sh | 190 ++++++++++++++++++
> >  tools/testing/selftests/dax/settings          |   1 +
> >  5 files changed, 202 insertions(+)
> >  create mode 100644 tools/testing/selftests/dax/Makefile
> >  create mode 100644 tools/testing/selftests/dax/config
> >  create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
> >  create mode 100644 tools/testing/selftests/dax/settings
> > 
> > diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> > index 6e59b8f63e41..8c2b4f97619c 100644
> > --- a/tools/testing/selftests/Makefile
> > +++ b/tools/testing/selftests/Makefile
> > @@ -14,6 +14,7 @@ TARGETS += core
> >  TARGETS += cpufreq
> >  TARGETS += cpu-hotplug
> >  TARGETS += damon
> > +TARGETS += dax
> >  TARGETS += devices/error_logs
> >  TARGETS += devices/probe
> >  TARGETS += dmabuf-heaps
> > diff --git a/tools/testing/selftests/dax/Makefile b/tools/testing/selftests/dax/Makefile
> > new file mode 100644
> > index 000000000000..25a4f3d73a5b
> > --- /dev/null
> > +++ b/tools/testing/selftests/dax/Makefile
> > @@ -0,0 +1,6 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +all:
> > +
> > +TEST_PROGS := dax-kmem-hotplug.sh
> > +
> > +include ../lib.mk
> > diff --git a/tools/testing/selftests/dax/config b/tools/testing/selftests/dax/config
> > new file mode 100644
> > index 000000000000..4c9aaeb6ceb4
> > --- /dev/null
> > +++ b/tools/testing/selftests/dax/config
> > @@ -0,0 +1,4 @@
> > +CONFIG_DEV_DAX=m
> > +CONFIG_DEV_DAX_KMEM=m
> > +CONFIG_MEMORY_HOTPLUG=y
> > +CONFIG_MEMORY_HOTREMOVE=y
> > diff --git a/tools/testing/selftests/dax/dax-kmem-hotplug.sh b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
> > new file mode 100755
> > index 000000000000..c8bbaf6178ed
> > --- /dev/null
> > +++ b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
> > @@ -0,0 +1,190 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Exercise the dax/kmem "state" sysfs attribute:
> > +#   /sys/bus/dax/devices/daxX.Y/state  ->  unplugged | online | online_kernel | online_movable
> > +#
> > +# The test needs a dax device already bound to the kmem driver.
> > +# If no suitable device is found the tests SKIP.
> > +#
> > +# A dax device can be provisioned with the memmap= boot param, e.g.:
> > +#   memmap=2G!4G
> > +#
> > +# then, in the booted system:
> > +#
> > +#   ndctl create-namespace -m devdax -e namespace0.0 -f
> > +#   daxctl reconfigure-device -N -m system-ram dax0.0   # bind kmem
> > +#   ./dax-kmem-hotplug.sh
> > +
> > +# shellcheck disable=SC1091
> > +DIR="$(dirname "$(readlink -f "$0")")"
> > +. "$DIR"/../kselftest/ktap_helpers.sh
> > +
> > +DAX_BASE=/sys/bus/dax/devices
> > +
> > +memtotal_kb() { awk '/^MemTotal:/ {print $2}' /proc/meminfo; }
> > +get_state() { cat "$HP" 2>/dev/null; }
> > +# set_state STATE -- write a state to the state attribute; returns the
> > +# write's exit status (0 = accepted by the kernel)
> > +set_state() { echo "$1" > "$HP" 2>/dev/null; }
> > +
> > +find_kmem_dax() {
> > +	local d drv
> > +	for d in "$DAX_BASE"/dax*; do
> > +		[ -e "$d/state" ] || continue
> > +		drv=$(readlink "$d/driver" 2>/dev/null)
> > +		[ "$(basename "${drv:-}")" = kmem ] || continue
> > +		basename "$d"
> > +		return 0
> > +	done
> > +	return 1
> > +}
> 
> It picks the first kmem-bound dax device and runs online/offline cycles on it.
> If the selected device is a real device with production usage, offlining movable
> memory will migrate all in-use pages.
> 
> Could the destructive parts be gated behind an opt-in, e.g. an environment var ?
> Or find the testable backend device instead of just picking the first one?
>

I think probably easiest to just include an environment variable, as
some people may in fact want to run this on a real device. 

Will work this in.

Thank you
~Gregory

> Best regards,
> Richard Cheng.
> 
> > +
> > +ktap_print_header
> > +
> > +if [ "$UID" != 0 ]; then
> > +	ktap_skip_all "must be run as root"
> > +	exit "$KSFT_SKIP"
> > +fi
> > +
> > +DAX=$(find_kmem_dax)
> > +if [ -z "$DAX" ]; then
> > +	ktap_skip_all "no kmem-bound dax device with a state attribute"
> > +	exit "$KSFT_SKIP"
> > +fi
> > +HP=$DAX_BASE/$DAX/state
> > +ORIG=$(get_state)
> > +
> > +# A failure to reach the baseline is environmental (memory in use), not an
> > +# interface failure, so skip rather than fail.
> > +set_state unplugged; rc=$?
> > +if [ "$rc" != 0 ] || [ "$(get_state)" != unplugged ]; then
> > +	ktap_skip_all "$DAX: cannot reach 'unplugged' baseline (memory in use?)"
> > +	[ -n "$ORIG" ] && set_state "$ORIG"
> > +	exit "$KSFT_SKIP"
> > +fi
> > +mt_unplugged=$(memtotal_kb)
> > +
> > +DRV=/sys/bus/dax/drivers/kmem
> > +AOB=/sys/devices/system/memory/auto_online_blocks
> > +
> > +ktap_print_msg "using $DAX (initial state was: $ORIG)"
> > +ktap_set_plan 8
> > +
> > +# A public (N_MEMORY) kmem node onlined into a kernel zone (online/online_kernel)
> > +# collects unmovable allocations and can then never be offlined, which would
> > +# wedge the device for the rest of this test.  So this test only ever
> > +# successfully onlines online_movable, the one mode that is reliably unpluggable.
> > +
> > +set_state online_movable; rc=$?
> > +mt_online=$(memtotal_kb)
> > +if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ] && [ "$mt_online" -gt "$mt_unplugged" ]; then
> > +	ktap_test_pass "online_movable: state=online_movable, MemTotal $mt_unplugged -> $mt_online kB"
> > +else
> > +	ktap_test_fail "online_movable: rc=$rc state=$(get_state) MemTotal $mt_unplugged -> $mt_online"
> > +fi
> > +
> > +set_state online_movable; rc=$?
> > +if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ]; then
> > +	ktap_test_pass "online_movable idempotent"
> > +else
> > +	ktap_test_fail "online_movable idempotent: rc=$rc state=$(get_state)"
> > +fi
> > +
> > +# A different online type is rejected without an intervening unplug.  The write
> > +# is refused before any hotplug, so this never actually onlines a kernel zone.
> > +set_state online_kernel; rc=$?
> > +if [ "$rc" != 0 ] && [ "$(get_state)" = online_movable ]; then
> > +	ktap_test_pass "reject online_kernel without intervening unplug (no kernel-zone online)"
> > +else
> > +	ktap_test_fail "online_movable->online_kernel not rejected: rc=$rc state=$(get_state)"
> > +fi
> > +
> > +set_state unplugged; rc=$?
> > +mt=$(memtotal_kb)
> > +if [ "$rc" = 0 ] && [ "$(get_state)" = unplugged ] && [ "$mt" -lt "$mt_online" ]; then
> > +	ktap_test_pass "unplug from online_movable: MemTotal $mt_online -> $mt kB"
> > +else
> > +	ktap_test_fail "unplug from online_movable: rc=$rc state=$(get_state) MemTotal $mt_online -> $mt"
> > +fi
> > +
> > +before=$(get_state)
> > +set_state bogus_state; rc=$?
> > +if [ "$rc" != 0 ] && [ "$(get_state)" = "$before" ]; then
> > +	ktap_test_pass "reject invalid state string"
> > +else
> > +	ktap_test_fail "invalid state not rejected: rc=$rc state=$(get_state)"
> > +fi
> > +
> > +# The online_movable -> unplug cycle once regressed: a re-online failed to
> > +# re-reserve the per-range resources, so a later unplug reported success while
> > +# leaving the memory online.  Assert each iteration really adds and frees memory.
> > +set_state unplugged
> > +cycle_ok=1; fail_i=0; on=0; off=0
> > +for i in 1 2 3; do
> > +	if ! set_state online_movable; then cycle_ok=0; fail_i=$i; break; fi
> > +	on=$(memtotal_kb)
> > +	if ! set_state unplugged; then cycle_ok=0; fail_i=$i; break; fi
> > +	off=$(memtotal_kb)
> > +	if [ "$on" -le "$mt_unplugged" ] || [ "$off" -ge "$on" ]; then
> > +		cycle_ok=0; fail_i=$i; break
> > +	fi
> > +done
> > +if [ "$cycle_ok" = 1 ]; then
> > +	ktap_test_pass "online_movable/unplug cycle re-acquires resources (3x: added and freed each time)"
> > +else
> > +	ktap_test_fail "online_movable/unplug cycle regressed at iteration $fail_i (on=$on off=$off baseline=$mt_unplugged)"
> > +fi
> > +
> > +# change system default online policy while the device is unbound, and show
> > +# the new system default policy is utilized across bindings.
> > +set_state unplugged
> > +if [ -w "$AOB" ] && [ -w "$DRV/unbind" ] && [ -w "$DRV/bind" ]; then
> > +	orig_aob=$(cat "$AOB")
> > +	echo "$DAX" > "$DRV/unbind" 2>/dev/null
> > +	echo offline > "$AOB" 2>/dev/null
> > +	echo "$DAX" > "$DRV/bind" 2>/dev/null
> > +	sleep 1
> > +	st=$(get_state)
> > +	echo "$orig_aob" > "$AOB" 2>/dev/null		# restore system policy
> > +	if [ "$st" = offline ]; then
> > +		ktap_test_pass "online policy resolved at bind: auto_online_blocks=offline -> state=offline"
> > +	else
> > +		ktap_test_fail "bind-time policy not honored: state=$st (expected offline)"
> > +	fi
> > +	set_state unplugged 2>/dev/null
> > +else
> > +	ktap_test_skip "auto_online_blocks or driver bind/unbind not writable"
> > +fi
> > +
> > +[ -n "$ORIG" ] && set_state "$ORIG"
> > +
> > +# DESTRUCTIVE: unbinding the driver while memory is online causes the resources
> > +# to leak - but the unbind should not deadlock.  Instead the driver leaks it
> > +# with a single "stuck online" warning. This leaves the memory online and the
> > +# device unbound until reboot, so it runs last - and only if we can run it,
> > +# leaving the restored state above untouched otherwise.  online_movable only:
> > +# this test never onlines a public node into a kernel zone.
> > +if [ -w "$DRV/unbind" ]; then
> > +	set_state unplugged; set_state online_movable
> > +fi
> > +if [ "$(get_state)" = online_movable ] && [ -w "$DRV/unbind" ]; then
> > +	mt_on=$(memtotal_kb)
> > +	dmesg -C 2>/dev/null
> > +	echo "$DAX" > "$DRV/unbind" 2>/dev/null
> > +	mt_after=$(memtotal_kb)
> > +	# The leaked "System RAM (kmem)" regions stay in the iomem tree; reading
> > +	# their names dereferences res_name, which a buggy unbind already freed.
> > +	# Walk /proc/iomem to provoke that use-after-free (caught by KASAN).
> > +	cat /proc/iomem > /dev/null 2>&1
> > +	splat=$(dmesg 2>/dev/null | grep -ciE "KASAN|BUG:|use-after-free|general protection|Oops|refcount_t")
> > +	if [ "$splat" = 0 ] && [ "$mt_after" -ge "$mt_on" ]; then
> > +		ktap_test_pass "unbind while online: memory left online, no UAF/oops (MemTotal $mt_on -> $mt_after kB)"
> > +	else
> > +		ktap_test_fail "unbind while online regressed: splat=$splat MemTotal $mt_on -> $mt_after kB"
> > +	fi
> > +else
> > +	ktap_test_skip "could not online device for unbind-while-online test"
> > +fi
> > +
> > +ktap_finished
> > diff --git a/tools/testing/selftests/dax/settings b/tools/testing/selftests/dax/settings
> > new file mode 100644
> > index 000000000000..ba4d85f74cd6
> > --- /dev/null
> > +++ b/tools/testing/selftests/dax/settings
> > @@ -0,0 +1 @@
> > +timeout=90
> > -- 
> > 2.53.0-Meta
> > 
> > 

