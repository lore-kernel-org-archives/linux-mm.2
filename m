Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61A15C98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5435E6B0088; Sat, 26 Sep 2026 06:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4A86B008A; Sat, 26 Sep 2026 06:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2BD6B008C; Sat, 26 Sep 2026 06:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11E2A6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:16:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93788A0890
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:16:44 +0000 (UTC)
X-FDA: 85255509528.14.406A838
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id A046F40008
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:16:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sJezQEgC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790417802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nuUo8zdKSoKE11B/ziniOjON7mdE/CfW6nfGNWVjAv0=;
	b=Gmc/+lhcg56S8t8MBVZ3iKknJjWBJE1x84qtZXgnCC3UIi83kKRu/Ff/OiNWTayMSx7EQ4
	sw/DMwsUOmY69uIaPnJmT9OdRVyi3rkSAGr7xYRKPrKZz+iVZmhy8xXc6DgRb8XjVe80Zr
	n2vo4wVQfBiLBV6FZ0ebq7Rt3hJ5qG4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sJezQEgC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790417802;
	b=qS/G7gos7szwbih9uwsV/5Ieh5/633RjJXmXinH5Ya3t5Z9Jmx7PNGoLdjY9P6YUn/NCiB
	t3vRP1vVSP/wghSfwvSnNYmEVymZ5hYoGdd4wdgeootnXZneE/UA/LaHDCriI62raDPEJJ
	pa2AmqhQ/Ys2ESKenXF+ZKfq6N9X2rA=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6aae37d33cbso2068947a12.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:16:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790417801; cv=none;
        d=google.com; s=arc-20260327;
        b=aDU9Veld+xRtDloT0PzTe2OeQmEIwkxrflk9RGkwn/vv40tkGz0HacaF4dRCjoPkHt
         8qOQ07wD4hN2L+kMJCC2wDBgUjk3OYPJlZEZI+2F77mxRvRzV45yXMbOcwDfwxEJMwx4
         SjYgRpqgRHCljNI9EWbYZubEV7XJ2KT00yyO68eQlW5NUslxnvj7CkkRgaX6wfLoOdB9
         IH7VPbGpr7ySHpCJi3kF6ej/SQk1CoIk/cvd3NgEJ6rwfoFpNe13T4/unTpt6n6f+eG+
         dQjPLtsGq3T7xSqboApxEamBguh37LbDoHTPYZuggX0wlAYMyil+4XWSQwF3J2rsXfXL
         Druw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nuUo8zdKSoKE11B/ziniOjON7mdE/CfW6nfGNWVjAv0=;
        fh=r4NGVX9p8mr1Ll8Jq/Hst///2hvssjRjYTQrsDESGfs=;
        b=GLVcLtaOes5NPrCZYU3ZXY2gk5bLH0M0NPGMRTZQq23VBYC4Vir/lhQd6m9VQieem1
         m9n+k+85WHwsOYc9I22DH7VthrSiD3KO2F+CuV69pfOEVR/Vd5AtkWjcrUc3Ghve865j
         7WskIyTEhjS5yEOA7JB1SKbhBbxhycILTcEHng54gApOQBbIo4mOfxPFYc7RJ48WmSGQ
         c6zNjEJWNoAwTWx+IUQNopxs6I5dvkvM+6GVpyNy2ZhbHQY8B0kj4XwIL3ROJk/XKppa
         f3//75KpLulObZ39jLjCRdzyjqFzYMFxHepJSqqbvO1x9KijfPU+dsNzEptqop0emE24
         hItQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790417801; x=1791022601; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nuUo8zdKSoKE11B/ziniOjON7mdE/CfW6nfGNWVjAv0=;
        b=sJezQEgCmthNndeg71WZ9kCXs9XX5zUUFp0exgxQ49W9xlRQseb2Ew5TONLq+nK9y9
         IcLhjo6vmfCsKpcUqK9XNVLSszr4IQswvU1Y0ymcBGj5LqeDKJ7tiS8pdzKB2EO3LeJE
         KLGFvX+lu3rdfeVq/9kLB0N39qRCw9SyxV1BMUlzM5wfcoNNEIoDYC5Q0RgtqcXbbae5
         MCfFa8WxlsPGM2cRGUzj0Vg6yU6VEbEMcMEL/XJHNPoSzv3P2TPkDNXqENce85Z7uZfw
         2IwwCirlWYzlxVjLVvTOzCwrnGeuyFq7QsRHNaRGdaU2bqWL1X/Rr4ZuiipybkqQXR0b
         hptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790417801; x=1791022601;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nuUo8zdKSoKE11B/ziniOjON7mdE/CfW6nfGNWVjAv0=;
        b=2XipVnHN4XqpdHpAPSmN4dOsPErqMG0ZxIURe5EPGpxoWmYuS/+IJz9GiCZDJoSYus
         UKakyNPzdYeMTIaQaeWDdfH9ZtIATkqdAXgI6LniWNwxvf/KKfs5FxvHKYswWjtUFi7b
         Wtvm32M7+GXK8dsKjCVfw390VKu+RuzboAcf7/Zl1S1tV+oaLK3owIOdLSFOicfik+dy
         DBqrw+aB2+iYRJu9CRhBZxFx7AWYV3eEY2WUQjvVom+kCND162cQHGnMbVftzmBZrp6Z
         ZnYbPyhr02csvNsvmDrSopyE0XK4V+oiIyLEW83uYSQViuIXF+zBCWKwl4aS/29q21Lm
         /BHA==
X-Forwarded-Encrypted: i=1; AKwUvBwGklRTc9gejQi+k2UFmtMOxEwm35rwEhGlhMlw1P+s1K5Rrvv2i9+RHaqw0sOBuPKnFBAEsVxdCg==@kvack.org
X-Gm-Message-State: AFuF++k1YiRb/JNVOPwl+BoXKjvanrXuoC3NmLKmhq/IRctVcI93gZU3
	6TEiV53u3WSdgs82FJCs3QleZ0Y4gbr0R+t/qn9eT8McjhRT6E19DEwDvhKcd8awjtIJRXE2F9I
	vV7SHCJOcVP7DjOCdnOWSO5FL9fBXGvk=
X-Gm-Gg: AYBFou27b9lS1IUk7bMkYMYDurMRDlnYqTmZT2msu/fAh2U+CLsa0uHHFT9EzaVVjvu
	1RkZBKeeV16U0eKYz45Qk0qFeR/pvKR7zP21y2Ebl5ARy9ZWa+2AV4ashwvnm47XoPBqTAHgucE
	shDbBmeLo6NA5Bf7SieLRzrboytvavKybZe8OeX/qo4cR7lfJe0fMEOnC00FyTO6cCVqT8DVT8V
	GV1/ts9zqSax0L1eHM/QjE235qx2ZXV21iTMQDgLEf0ZF5OhbTGsb98z3CTBhG+9bStlN9DbB/y
	b3kfLPHrICZVjYbkegszVS5XlIja724BJdQ+x1M5xkZfAFrZuDccll27W9m8BP2QF38WAihKLb5
	NZVIFBITS4WM=
X-Received: by 2002:a17:906:dc89:b0:c26:3341:b8f6 with SMTP id
 a640c23a62f3a-c2ac23a79a0mr705591166b.31.1790417800888; Sat, 26 Sep 2026
 03:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
In-Reply-To: <20260926045517.3458413-1-matthias.goergens@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 26 Sep 2026 18:16:03 +0800
X-Gm-Features: AclHuK-9Dsy7rrAClr-629S5BXo_K2Hom1PYuYOl9rMJseRXC4FOvcoZCXsi7Gw
Message-ID: <CAMgjq7B7jem_dwtUEX7ZJPQm_pKBegR6WS9+B7nFp-gZugpUng@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Baoquan He <baoquan.he@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, Barry Song <baohua@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-api@vger.kernel.org, Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, 
	Karel Zak <kzak@redhat.com>, util-linux@vger.kernel.org, 
	Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Pavel Machek <pavel@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-pm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rf5j93kk8co9kugp6wck7k3rp9hc8am1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A046F40008
X-HE-Tag: 1790417802-890119
X-HE-Meta: U2FsdGVkX18J+a+BMT3MZsFJJSBBi7HLtiRC/P7Rbb6yChIad4iwnNBdTBJGkxiEu8V/t0CEq/i5vzRX1dvtgxgN7R5Yrul5KZ0ldJMtJ8/iqWx7Njfax2Us0SpHywwaINqjQMQbeAJ9QNhn2ct2WEB+48L7kuqFf/V0y5uOw73iYFGXqJbGwjmqrphgQYMyAN+WSxn9yRikNWDP+JuV8DmVqmnswl7FG0eId7B/3of1OTdNav+a3Uauou9Pq3fSYbV8bXXqB6Zzf/MhbgUWO8ILzWRw+Yc36n6b79TluUizLx2n9WQ5Iqbdbvzo7dBGmIyTm+jO7+uBzLPIz4MvigBOur3IRjUJi/Ov1xYvZv4QShTv2hnG7ldhra/lOjOv1g0r3Bt1m0ae0VcBlRIxkSlvJUwnajIeYnd+TuS0uZcgQx0SFI/PB6UnZOz6ml0VQwL36KIIvhRdZeZ/GfrC5rbTxThFge4FN4bkbrEJW5Yk+p45oIPjxdKjcFGEgA97+ql1D107kDv3xHgBqfO5/pSrZ1g7jd39SsMmJGvCaMNw9VQXusk1CHUlJOa9Ee3/vWtx0H4d5BMGp+kP+uhdCFODk9S4I4W1S3JHizQOzXvh0+F285Ukrd/lIaKX+tsv/TPYcM8kkwNB/Lo9mT7S3vBuduEMEtJeD6jgOSQeWWbIm+q0w7v/boULBSSIHM7L2oC237XmO8Iiz/GhWLMmqzUtVcV8Bp8ml30rZOjyoQIRCzPM1+DKSvOLRqpDcTZ77vPULLgWkLIp1x8LLj27AWaYwhqBHfA29w6gANSpiGwE+59okE80NYkb2lo2mCw7vj3+6IfmLowOnP8rFnK4Z563wnWEZXL4ps+xSzvUzh58kWmxmNcKQJ/K7NfkqQZLHQB07tNoPytVpFxxbLELKI0DbHDlhFLOmQnk3H6ajTXUBUBQxuceUiuJOeEdaAdb9AfxZ4PLoHlM2ilGaq5
 aCaSQTGc
 H0zTAxT5LuFbk8WoroO6J+4vZMIe2RcAeRoAoL1xMWL9yaObD7maVew+1iWlQ8Zsq0NaIe+gh74iQ2Sng+6ybOQTCkah8BsTYd5BfJOwR2gzLkTLJMjCMC+5pG7OUuWLvoNmjKgm2pN7KDOwucjB8A1vV338/EKK7+VYtfCWYppv5g2XzlZbjd1E/SjVOJdmnl6kqYGwrAC1wH369KUfdREc1wx2WyzHxzk8tQVNHXIfcHoFV5cKmk7dfLrtHLor7jQP7EB314uuJAKPwS+TT1yMTlQNI5iv/PuTAjBAQJsAhvE+Y2cCxIt0AjdJam1r/JwxGKopmOYJJn0XRajRJuDvkNIAQfMSOlqK2naRitX7XO0JhojCZ2FOusBCxsZ/1nJPe2VZBayynnE58y6UcWmGIAA27rzg/ecFTDU1dJ8MyuwNL7i9h6SmW26xAUXfwErv7vfhfvTkQsXm1uEPOFoLfH0paPxSkqQVz+/9pVafhk6Ebl9Y+/L+IQULIfkEVJkIgxLir64BQ+QZvjOC4SheABsN/xBBUdn82aDYcttcJ1skhR0uJmS9BZOXLeL8Qn8srXKyDHEYXP+ZlyQIJRMigeD9mNM5KwzufD9tSeieLn1UqIP8ui7hXYrlRlCuiXuDNyLHoFxIZ6yZd3tY3Ut/N8JYuBmGoAhB1iDlq9QlI94lzZi8PJVo5W2sPuFe3DdYx8VRVsUNFIKsIEJ4YQuwQtBRykpybkgOKy5BYxrjG6VVqe/DFGoyM4wp363wNJ8qZEKTeo3WkTkSL6IJt+2ZfFRgg3/U4Q68MdW3nmkASGF2eTlcSxclEEPzmV4tENCCMT9mc8jw+QwGTgALld0zw7CB159EQGY2SdstcAepPGv3QCs/otRUzxQxtCDUKy3xamMWn00gOw1P6MWyQSrGY2Eud//oNPfzb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 12:55=E2=80=AFPM Matthias Goergens
<matthias.goergens@gmail.com> wrote:
>
> This RFC adds offload-only swap areas for deliberate cold-page offload to
> backends unsuitable for pressure reclaim. ZFS zvol swap has documented
> deadlocks under memory pressure [3]; compressed swap is another target
> because writes may need memory despite free logical slots.
>
> Explicit proactive reclaim can use these areas alongside conventional
> swap, ordered by priority. Ordinary reclaim cannot initiate non-zero
> writes to them, including through retained swap entries. Conventional
> capacity is not reserved for emergencies. Operators choose the policy;
> the kernel does not measure headroom or make an allocating backend safe.
>
> TMO/Senpai [4] and DAMON_RECLAIM [5] are related cold-page reclaim
> approaches. This RFC admits offload-only swap through memory.reclaim and
> per-node reclaim, but not DAMON. Other related work includes per-cgroup
> zswap writeback control [6], Virtual Swap Space v4 [1] and swap tiers v10
> [2].
>
> The util-linux companion [8] proposes swapon --offload-only and an fstab
> option. Older swapon silently ignores the fstab token, so persistent
> activation needs discussion. Apply the separate i915 fix [9] first to avo=
id
> a pre-existing folio-lock leak when shmem writeback is skipped.
>
> The series fixes zram selftest device tracking and error reporting, adds
> the swap policy with DRM eligibility checks, and tests routing, workingse=
t
> activation and retained-entry write refusal. It is based on mm-new at
> 995829088503.
>
> Feedback is particularly welcome on:
>
> - Activation-time eligibility versus backend placement or migration:
>   is retained-entry refusal, with possible reclaim churn or OOM,
>   acceptable without migration?
> - Eligible-capacity accounting, including overcommit limits and OOM
>   scoring; cache recovery, cluster invalidation and workingset activation=
.
> - Persistent activation and visibility: current swap listings do not
>   expose the policy.
>
> Validation includes x86 builds, affected arm64 MTE objects and builds
> without swap or memory cgroups. QEMU tests covered routing, retained-entr=
y
> recovery, data integrity and cleanup, with negative controls for write
> refusal and teardown failure.
>
> I have also been using this policy on my own machine with experimental
> bcachefs swap support, with no problems observed so far. Deliberate stres=
s
> testing is confined to VMs; I do not deliberately stress-test this machin=
e.
>
> Changes since v1, incorporating Sashiko's public review [7]:
>
> - Improve selftest isolation, retained-swap measurement and memlock skips=
.
> - Track allocated zram devices, wait for udev probes and report cleanup
>   errors without deleting data through a mount that could not be released=
.
> - Clarify activation, capacity reporting and conventional fallback limits=
.
>
> [1] https://patchew.org/linux/20260825153238.2695446-1-nphamcs@gmail.com/
> [2] https://patchew.org/linux/20260713025644.170839-1-youngjun.park@lge.c=
om/
> [3] https://openzfs.github.io/openzfs-docs/Project%20and%20Community/FAQ.=
html#using-a-zvol-for-a-swap-device-on-linux
> [4] https://engineering.fb.com/2022/06/20/data-infrastructure/transparent=
-memory-offloading-more-memory-at-a-fraction-of-the-cost-and-power/
> [5] https://www.kernel.org/doc/html/latest/admin-guide/mm/damon/reclaim.h=
tml
> [6] https://www.kernel.org/doc/html/latest/admin-guide/mm/zswap.html
> [7] https://sashiko.dev/#/patchset/20260914104501.3960616-1-matthias.goer=
gens@gmail.com
> [8] https://github.com/util-linux/util-linux/pull/4633
> [9] https://lore.kernel.org/all/20260914105606.3997649-1-matthias.goergen=
s@gmail.com/
>
> v1: https://lore.kernel.org/all/20260914104501.3960616-1-matthias.goergen=
s@gmail.com/
>
> Matthias Goergens (4):
>   selftests: zram: track owned devices and report cleanup failures
>   mm: restrict offload-only swap to proactive reclaim
>   selftests: zram: cover offload-only swap policy
>   selftests: zram: cover retained offload-only entries
>
>  Documentation/mm/swap.rst                     | 105 ++++
>  drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  |   2 +-
>  .../gpu/drm/i915/gem/selftests/huge_pages.c   |   6 +-
>  drivers/gpu/drm/msm/msm_gem_shrinker.c        |   2 +-
>  drivers/gpu/drm/panthor/panthor_gem.c         |   2 +-
>  drivers/gpu/drm/ttm/ttm_backup.c              |   2 +-
>  drivers/gpu/drm/xe/tests/xe_bo.c              |   2 +-
>  include/linux/swap.h                          |  29 +-
>  include/linux/vm_event_item.h                 |   1 +
>  mm/memcontrol.c                               |  20 +-
>  mm/page_io.c                                  |  24 +-
>  mm/swapfile.c                                 | 123 ++++-
>  mm/vmscan.c                                   |  31 +-
>  mm/vmstat.c                                   |   1 +
>  tools/testing/selftests/zram/.gitignore       |   2 +
>  tools/testing/selftests/zram/Makefile         |   4 +-
>  tools/testing/selftests/zram/README           |  20 +-
>  tools/testing/selftests/zram/config           |  10 +-
>  tools/testing/selftests/zram/settings         |   1 +
>  tools/testing/selftests/zram/swap_offload.c   | 425 +++++++++++++++++
>  .../selftests/zram/workingset_offload.c       | 207 ++++++++
>  tools/testing/selftests/zram/zram.sh          |   9 +
>  tools/testing/selftests/zram/zram01.sh        |   9 +-
>  tools/testing/selftests/zram/zram02.sh        |   9 +-
>  tools/testing/selftests/zram/zram03.sh        | 174 +++++++
>  tools/testing/selftests/zram/zram04.sh        | 164 +++++++
>  tools/testing/selftests/zram/zram05.sh        | 447 ++++++++++++++++++
>  tools/testing/selftests/zram/zram_lib.sh      | 189 ++++++--
>  28 files changed, 1926 insertions(+), 94 deletions(-)

Hi Matthias

That's a lot of changes for a rather limited usage. IIUC what it want
to archive is, for different kind of reclaim, swap operations should
only go to certain devices?

This really sounds like another usage of the swap tiering design: A
default per-cgroup tier setup, and a one time tier limit during
proactive reclaim.

Just like we already have a "swappiness=3D" parameter in the reclaim
interface, perhaps adding a "swap.tier=3D" would be better and much
cleaner to achieve the same goal? Based on Youngjun's work here:
https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.com/

