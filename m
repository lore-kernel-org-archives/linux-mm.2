Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2599CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58F18E000C; Tue, 11 Nov 2025 01:48:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09D68E0002; Tue, 11 Nov 2025 01:48:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47118E000C; Tue, 11 Nov 2025 01:48:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3DBB8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:48:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34A1E88BB7
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:48:10 +0000 (UTC)
X-FDA: 84097396740.24.F3169CC
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6302D140004
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:48:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OPXsVYnv;
	spf=pass (imf26.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762843688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvJiQeCWKw1rGFL3Q8oVIkh9JusjXZv2HTeEiaF2AmI=;
	b=qqikTgLYhWKIlJ7Sc84DCYJbLrhpj9PrP5ot3pfK8IbWA6VXd+ZJt0SDXrfsNdhbTKZ1WA
	BsI9gUa+HJdb8pNanHzAl+BgVySokzRuAdhkpytQyZ2NfGhV59CFxG5sLo4fgV/lskggD4
	bLzFJd/erFy/oNJf/eSWpv6p9ngbsq0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OPXsVYnv;
	spf=pass (imf26.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762843688; a=rsa-sha256;
	cv=none;
	b=5hvPEfHF/JI9IfY3DzqoAAmi69v+JupIgANAeRMrOBJnrE3rsolFoUkXYHlCJI22GPX64k
	bVRXqOIYAzRaFCeFotZGWCJR1rBDeX0c+OwPVSUKe7oh2yk8Sd5bsfFVrNWwCugis+2jiN
	mGj/0Z9Ctm54agv28DhLomxjCUbHM/s=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762843684; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=cvJiQeCWKw1rGFL3Q8oVIkh9JusjXZv2HTeEiaF2AmI=;
	b=OPXsVYnvf2faSKDG64zUCcwmmgFybqvU4WWUv2LRidkO/4d32W7fN/rFPbO2r38oYTlr8IRJbI0IIIgOEaR+gECtjw/pxHps0xLDORqJliWR3qmpgJ88Adg0akGh5nlkegs+XffY/LARgvlbTvG9jryCQMqsXPsCeAqJxTFnr64=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WsACUYD_1762843681 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 11 Nov 2025 14:48:02 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
  linux-mm@kvack.org,  Andrew Morton <akpm@linux-foundation.org>,  Kemeng
 Shi <shikemeng@huaweicloud.com>,  Nhat Pham <nphamcs@gmail.com>,  Baoquan
 He <bhe@redhat.com>,  Barry Song <baohua@kernel.org>,  Chris Li
 <chrisl@kernel.org>,  Johannes Weiner <hannes@cmpxchg.org>,  Yosry Ahmed
 <yosry.ahmed@linux.dev>,  Chengming Zhou <chengming.zhou@linux.dev>,
  Youngjun Park <youngjun.park@lge.com>,  linux-kernel@vger.kernel.org,
  stable@vger.kernel.org,  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH] Revert "mm, swap: avoid redundant swap device pinning"
In-Reply-To: <CAMgjq7BsnGFDCVGRQoa+evBdOposnAKM3yKpf5gGykefUvq-mg@mail.gmail.com>
	(Kairui Song's message of "Mon, 10 Nov 2025 19:37:01 +0800")
References: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com>
	<875xbiodl2.fsf@DESKTOP-5N7EMDA>
	<CAMgjq7CTdtjMUUk2YvanL_PMZxS_7+pQhHDP-DjkhDaUhDRjDw@mail.gmail.com>
	<877bvymaau.fsf@DESKTOP-5N7EMDA>
	<CAMgjq7BsnGFDCVGRQoa+evBdOposnAKM3yKpf5gGykefUvq-mg@mail.gmail.com>
Date: Tue, 11 Nov 2025 14:48:00 +0800
Message-ID: <87h5v1jc9r.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6302D140004
X-Stat-Signature: qzidy8wskkzydjk96pbbfz1sk5aaus5x
X-Rspam-User: 
X-HE-Tag: 1762843687-66911
X-HE-Meta: U2FsdGVkX19hDVUyELaOphyhNS4JAL7c1JiPHZC1op/sRKcWkVQ93PpA4sLMYwQn6nZjtKI81TwepC2mnc/oakqGD5/rH2Ug6z1XKcX5lyYGnMQbBhR+Hng0/FOe4F/aWRD5LuH1Y59pR+tdraKGPwXx3gD6yGvBSHQRIY+VzooSPf0aQ8nznz+3nfl3itRIpiz/6GFMVB8uSgGikqvzMx2PZS9D0/RBGa++n24FPmkQQq9lDDa1j9tbNHuCrs6g1TIHKwKIVsgRaprPGcq9M7nr5crsdB8qo7JsTCkwU7FrgOSH66m8WWhNoMuSw+ma2ZaOtJ4FGc1/u8NWXLx+WcfTXFMwIrqoXcoHNr4wnI2GhsqwsTgLQDuY50pEa7PRIAaTNATT9HCnA7FrcTiz0+t3m588+cSSGZvT5LLHg46n5FyJPOga1IWWSthaftayFnRiyYnAvjlcNMOla7QkhGMDDCkdx5pIMzMnq3KnqOHmCKKhbWH9NCImHK/TC54KwxfwRYlWkqDixzTuLOWe9hUsZIQrpuMW6s0HSuOiFcZKYq98hdzF7f+KZEy1X30CfhY1Ux4zzLjR2PpzOd+AsYfeRSkoyFitUcIdhhtRTcahXNYAMWSaGGpFvujErQr2To9dHhonC+isqCHrD8NsUeX/TlNTIzcoENtuR3hmAHL+bWXPZryPbUJgxo3vJvAaqCM5F5W8nups9UQ8OZ9vKfZsHO0/HKSXURzGe6e/Z/8Jt+Qkb8BXMN6kmWuTNFy4HMcxaAZz1KOwVOY019hAfmyVqw2Dvbsum8N2HZxInkO/LWi3zhw/RRU0uKtP1yvd5lcYtmpX8KLsHXK0ZT1VXBBfgzmFxJOfgX2t7COP9cWdi2sMPsASSwEcf+ZGAUxeEyNj98TEFKn+L01pa9jIeTuMcVME+A6g1zhYZtp20dLVaUQFYrL5y8N4pniLt+OOojx6Sf6NC5yJdHWjUfk
 OQuul1BM
 btc6JT2dj04YIBXlrFJVvFd+QMDmugH01+JIavozmmcKiWNHDZOiUQIeof805u7YI3cjExWAworPyH4ezfIwUsKxW8jYIGeJO6IcrYKOk28iWhGGI5zmI7+yFJaQdbXQA7PCS7s6tNSSzR2cb2kCmrBXitGEdgapZW4aeLVw7JwFpejUzone7xtuThUTh7PR/eG7FY3pI1BSDbTtJYcBn4AE618uXdMjRtI/VQKxII+3G+UP0HldXY77xwCMbfRGaQT/xMsZ5CcL8Kbrq2vcLIlQopReC2aAu6rBwN5cD/QqVU6MyX6uTVfa/YKm8xQblHyjda/+bQ9KTrIHVGzIATyqsU+6OBl9ePT8rKK5k6EPyolQe9E0mA6YXHZkVPC8J0SPpNblGCJtZnYIvckXx9HJh2aZtIqGl8uuLmPKaaevO8h0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kairui Song <ryncsn@gmail.com> writes:

> On Mon, Nov 10, 2025 at 6:50=E2=80=AFPM Huang, Ying
> <ying.huang@linux.alibaba.com> wrote:
>>
>> Kairui Song <ryncsn@gmail.com> writes:
>>
>> > On Mon, Nov 10, 2025 at 9:56=E2=80=AFAM Huang, Ying
>> > <ying.huang@linux.alibaba.com> wrote:
>> >>
>> >> Hi, Kairui,
>> >>
>> >> Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> writ=
es:
>> >>
>> >> > From: Kairui Song <kasong@tencent.com>
>> >> >
>> >> > This reverts commit 78524b05f1a3e16a5d00cc9c6259c41a9d6003ce.
>> >> >
>> >> > While reviewing recent leaf entry changes, I noticed that commit
>> >> > 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning") isn't
>> >> > correct. It's true that most all callers of __read_swap_cache_async=
 are
>> >> > already holding a swap entry reference, so the repeated swap device
>> >> > pinning isn't needed on the same swap device, but it is possible th=
at
>> >> > VMA readahead (swap_vma_readahead()) may encounter swap entries fro=
m a
>> >> > different swap device when there are multiple swap devices, and call
>> >> > __read_swap_cache_async without holding a reference to that swap de=
vice.
>> >> >
>> >> > So it is possible to cause a UAF if swapoff of device A raced with
>> >> > swapin on device B, and VMA readahead tries to read swap entries fr=
om
>> >> > device A. It's not easy to trigger but in theory possible to cause =
real
>> >> > issues. And besides, that commit made swap more vulnerable to issues
>> >> > like corrupted page tables.
>> >> >
>> >> > Just revert it. __read_swap_cache_async isn't that sensitive to
>> >> > performance after all, as it's mostly used for SSD/HDD swap devices=
 with
>> >> > readahead. SYNCHRONOUS_IO devices may fallback onto it for swap cou=
nt >
>> >> > 1 entries, but very soon we will have a new helper and routine for
>> >> > such devices, so they will never touch this helper or have redundant
>> >> > swap device reference overhead.
>> >>
>> >> Is it better to add get_swap_device() in swap_vma_readahead()?  Whene=
ver
>> >> we get a swap entry, the first thing we need to do is call
>> >> get_swap_device() to check the validity of the swap entry and prevent
>> >> the backing swap device from going under us.  This helps us to avoid
>> >> checking the validity of the swap entry in every swap function.  Does
>> >> this sound reasonable?
>> >
>> > Hi Ying, thanks for the suggestion!
>> >
>> > Yes, that's also a feasible approach.
>> >
>> > What I was thinking is that, currently except the readahead path, all
>> > swapin entry goes through the get_swap_device() helper, that helper
>> > also helps to mitigate swap entry corruption that may causes OOB or
>> > NULL deref. Although I think it's really not that helpful at all to
>> > mitigate page table corruption from the kernel side, but seems not a
>> > really bad idea to have.
>> >
>> > And the code is simpler this way, and seems more suitable for a stable
>> > & mainline fix. If we want  to add get_swap_device() in
>> > swap_vma_readahead(), we need to do that for every entry that doesn't
>> > match the target entry's swap device. The reference overhead is
>> > trivial compared to readhead and bio layer, and only non
>> > SYNCHRONOUS_IO devices use this helper (madvise is a special case, we
>> > may optimize that later). ZRAM may fallback to the readahead path but
>> > this fallback will be eliminated very soon in swap table p2.
>>
>> We have 2 choices in general.
>>
>> 1. Add get/put_swap_device() in every swap function.
>>
>> 2. Add get/put_swap_device() in every caller of the swap functions.
>>
>> Personally, I prefer 2.  It works better in situations like calling
>> multiple swap functions.  It can reduce duplicated references.  It helps
>> improve code reasoning and readability.
>
> Totally agree, that's exactly what the recently added kerneldoc is
> suggesting, caller of the swap function will need to use refcount or
> lock to protect the swap device.
>
> I'm not suggesting to add get/put in every function, just thinking
> that maybe reverting it can have some nice side effects.
>
> But anyway, this fix should also be good:
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 3f85a1c4cfd9..4cca4865627f 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -747,6 +747,7 @@ static struct folio
> *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>
>         blk_start_plug(&plug);
>         for (addr =3D start; addr < end; ilx++, addr +=3D PAGE_SIZE) {
> +               struct swap_info_struct *si =3D NULL;
>                 leaf_entry_t entry;
>
>                 if (!pte++) {
> @@ -761,8 +762,12 @@ static struct folio
> *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>                         continue;
>                 pte_unmap(pte);
>                 pte =3D NULL;
> +               if (swp_type(entry) !=3D swp_type(targ_entry))
> +                       si =3D get_swap_device(entry);
>                 folio =3D __read_swap_cache_async(entry, gfp_mask, mpol, =
ilx,
>                                                 &page_allocated, false);
> +               if (si)
> +                       put_swap_device(si);
>                 if (!folio)
>                         continue;
>                 if (page_allocated) {
>
> I'll post a patch if it looks ok.

LGTM with the NULL check as you said in another email.

---
Best Regards,
Huang, Ying

