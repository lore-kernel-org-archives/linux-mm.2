Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 611B9C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED8D6B009D; Fri, 11 Sep 2026 10:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676976B009E; Fri, 11 Sep 2026 10:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541116B009F; Fri, 11 Sep 2026 10:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC6B6B009D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:37:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 848581A02A7
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:37:31 +0000 (UTC)
X-FDA: 85201734702.05.87F4D23
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id B5E8C20010
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:37:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KkbZ5vtO;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789137449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2Ov6MxIFeBvn1siphW3kcaZJl5WIgV8anby3r7O9WA=;
	b=tsD8n32+9bgYjTM+hF2VbGFO1OojxXWDDLz1u3hz21B4AhAChbkDJFZ8QQcfxyCjNcBkDp
	HXU0kygW3yeMDp3mY6emyJYiOZSCWmTKJ0tqv4D/qoE2tYtLotl0M+i5WmHC+cCAk6cksq
	UU9ADS4lSuwdONyX79P5iUkrqxcmyLI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789137449;
	b=mwrGPKXjut/d5S5A8qsNhgET7Nj+iwJikzmbU0CRfyBYiI1yAs2ciMHf2NRHACdJRS1WVD
	jg4GyVTmAZMxSV2J0MSF5YSsZubM5ZDPg9bwn0TESoIsCUmMklUwMhQudnjYQUNm4l9nxK
	ZCEP8Uwofa7kEFUUb8qIdNJbErvW0nU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KkbZ5vtO;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4af7283bf83so534907b6e.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789137448; x=1789742248; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P2Ov6MxIFeBvn1siphW3kcaZJl5WIgV8anby3r7O9WA=;
        b=KkbZ5vtO9PEwMKS6uENdcOslMxatGyYeeXH8KvjnbC05D8EmMMjR1zUycI3/RnRw6z
         GHwUI+TGTeZdOsdcs89GHR/gkXjPM1hv0WgLULTNvqjhmVXfRNX3obzJeXTFB0ffu/Cg
         GWnf8IwRzPzqu35FNo61a1hvy06v5eV4UIYgrxTJEUgAr2W415YxsJNZdSTYD1Blt0YA
         qlDZ8kjedLDr/HfILGnIT4B8bG4DMxUoSlrbUUtkzWFYNg1FnZd7Moe3TuddyR/BD2mi
         5ovMw9gEV93iULiiUTHRsL4hXtl8fX8KegiLlZesYbryAJXneuPo2mR+xXUGxPoCN4jU
         EcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789137448; x=1789742248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P2Ov6MxIFeBvn1siphW3kcaZJl5WIgV8anby3r7O9WA=;
        b=JYTP7Cet9c95LCIKKTTQeHUW+3gnuzTinaBnl1eiHTCEo57tRWRPsQchw2tn9yr0EM
         SN1hnSTQZkseVg5Ybq+nnmkDVKPBP5FWSn9wzrpiLmqV/Irx3mSFrSEqZPj784BoGBn7
         dVbGgI9eEE3XJLetqfPAoQA66x0U3utaU1G0MTi5i4nj5a0HXCaFi0tHYSnOTtgR6pAM
         mqaHmv5iA9DEKUUy47YAfRiZexLBh7n/bSQOzYqqFR1xc5/PwbdwTB9IJpK3BZy/G3jS
         HSp1SKsjMCfPiktlHi1UfV8VK3ibq9w3eDcYn9XcAR1OBoVuvtS5KzrDuTNUHumTYNec
         Qndw==
X-Forwarded-Encrypted: i=1; AKwUvBxBSCmglFsCKVP7Z284zz6N5sJalGJkDBmP/0CIsFB2xWxsBay3xCv3zIRfSYvwc/heW4VAjYrcZw==@kvack.org
X-Gm-Message-State: AFuF++ljm+gQH9i5xxDSwRHviA+QEN65CZDm0bthfltGeb5ZBuDC9BSW
	BibjZ1sI+L/CbOolTp5IFgdGhy5WtYOWAvb9Mv3GQD8GAgGPmAGGR46c
X-Gm-Gg: AYBFou2bfH/e4L0jREPY0GGmE5KOEW4lIsaMCn+EF6gk4ifAdsccEYKbBHze3XtUeEL
	kj0OBQFv3+jaH4ett+gHngPlbC+1tZO4W+l6QyeD9f/QmFMsWQuLAzQs93UWEN4/dO+rawrn6By
	UEBshiCHt1i8/a9D/Sa/395lflf8S3olIXZx4fTfXDwVZGJMu6cpwaUGIjt8yo5J2yQJrkPJ2Kl
	z8yhXmc9L9Voj3yX/jdovSMAXt+b9a3tyM41nL6pYLBqpGWlCEWky/tTYfgMEG3ddOBuB578dfg
	ep92i93ACM3nPJ/HvaH5xJtAt3OP2+oda1aQp7HoRi9dPbnhtOqbbBsRUEhiz8Tu1WgzbRf1dep
	9tWVBVsmuj6ZGKbPMB6iyGbjnttPBDlBdh1cyee0KjbF+oXuJoABaN3N+4gtvd9uWXxJpEMN8KH
	PDJlocuQoFR4Dm5P99Bk7Cmz9QQoPJXsaghCnntFIY05IWIUWcrcAlzXoEG1flTUc0S3qM/fO3l
	buq7r/S4s7ovedaGZJQSDtE7VlUug==
X-Received: by 2002:a05:6820:c3ce:10b0:6ba:2d85:8f49 with SMTP id 006d021491bc7-6c0bd5873e7mr2467455eaf.65.1789137448463;
        Fri, 11 Sep 2026 07:37:28 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5c::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6c0990ccbdfsm2617969eaf.4.2026.09.11.07.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:37:28 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Hongxiang Lou <louhongxiang@huawei.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wupeng Ma <mawupeng1@huawei.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	fvdl@google.com,
	jthoughton@google.com,
	rientjes@google.com,
	vannapurve@google.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ackerley Tng <ackerleytng@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: hugetlb: Fix out_put_pages subpool reserve calculation
Date: Fri, 11 Sep 2026 07:37:26 -0700
Message-ID: <20260911143726.3689114-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909-hugetlb-subpool-always-track-used-v2-2-30c5d83b572a@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B5E8C20010
X-Stat-Signature: hq9pprwwi4hr1dd39cogqr1h95dgrnqj
X-Rspam-User: 
X-HE-Tag: 1789137449-452675
X-HE-Meta: U2FsdGVkX19KlhM9V12kiMD2gcMWzsSDUinN+UZfQftapaNNH7DCU3MhB78oMXBgdtQe3fQpsktLNTK4u5ddi5QuR5vEUQ2zeVCnWpx8vAYEK02DjD7Pxf6imYU5LwM/jSOzDDRWnGXlIqd18RPuajqmtmLPp5jFReGWfKRgi65jzpSK+1I1NrsfrXNEF4TrFLuclCyUz5+wrVvnjB0Wf4HfSAOFJ092/vOQI9wJU4bENw1OZB+et5lMChxdMm27nX+gcLTE32wgVL2Tb902Cz6Y6+j7VE2IkL52v5PrP5dypEYrDvZ5weFur43mC+A5uxtpedrt1BQfbGrSKkNT/p4SornS/1wtuN3WjSXRJ/4I6H/1ZQT2WKnU94EfGb2gl6zdfVchDFStBqscQNBhceQmDgyUE/LfO9oB6OwQcVKjm3YTNz/nPQen7n0x03RAHacipTuxxtl43IpvVc2lZpNvC8fcBKVlsuYePC8o2johR3v3HJ6p6ksBy8YVlqyqB01IwN4oFkAHQmf9iSiSgzU4p3QE77QQ8RfAN3A3tk57Je7O+Wh862AMM7sa2TLBoNq5FcPWujmJDXtMLPnX+V7QQjbvjLc/1EpFayThhTzFBNhlAZY8Bqyj2IEZo1gWOkXZuSITw41QJ4i31VtbhrjH/nzX7EURpTYUJmuX5WbEXrE3nzKpPDHC8gmz07iszQNehpwRV0QqYs4fnXE25gMDE+7D018S+L/teow0U+ljZn00OQPcZkAEjY00F35aw5Pan7d3kWoIGFNUH0ScfeOVYq1kCVqTtfUwDHCUzYv5VgJCKpXt/WBC47JL8dnF7SzecYB4o/cFjOX7tWetCXFohphIjISNRXq5rLtUC52qAg10xr0ePpLNxoqK+igxvWypa+G2G3A5ZY89Q5Jir1HzvSnbxG4Z6/mSuOY+Tw+r/eiUODGxou8knlS67XqrcQCNc/DgWQp4l6Z09YZ
 RxKx9ilV
 2sa8SrbQ/1aGHkq6fngJ/gylq0upAw3rt6/PZ8YDOw3MSdGYJcBaqEMvubgXQ7tm1YiDTN8Kuh2NqOU0iTh4TdRgZV05QIPWPLpFFnKqZSYY+jFjbW33HQyrK3hJLy79HPe2SjALbfppU0Py4qGCvGUDh979E85eOqA8IIPtqpNazm+PAzHTbHgyLjJ8+vwlLmX87CnrV2lkxvYMS4W5IkSDu3u6wwg+JanGEuuKT176bf6+d0jkSh9aT+KZeAcPPz3q528Y5e3yF5RG4nyPFipqv20jnfWEOVJNeuiOO0NLhtEOJu4cWgYcUrq3NZXCIkLTwJS2f7n/mARllGSIea6tt2KHHlQ9TYff3qD92mfR4GpTBGkYVYcF9RguFI2spqQ0HOaSqiiBHph0p86FSwFEaYdOk6cBHzDzohgmGSBd+hzjcd3V9WhCtNzp7Rkc0xmll8Tag1gDG/7oX+ga53nq8VKLEgRpdlILTHue0v+ku/vn60F2YGLhYTu4jQgqjFcYo+lW3v1eVZt4XISGVYbSXkPFYRN1cJ3LqQPkyrpg7qSJKntTdc5Yd51Bg4M1BA6kG51OmbIDLbok4yJycOh4AQEdIe10tvKXD1o44mzKDLGEOIPZgea1qdPG8mHUzkMVCOSQptUjWaHIcrIuVqaXPssCXWWOFz/nobv10Zx4s5lFqkOQuPxrdEk2lLZwnklcz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 09 Sep 2026 14:49:27 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> From: Ackerley Tng <ackerleytng@google.com>
> 
> When reserving pages for a mapping fails during global accounting, the
> error path rolls back the adjustments made to the subpool.
> 
> Currently, this rollback was performed in two separate steps:
> 
> 1. Returning only the portion of reservations originally satisfied from the
>    subpool
> 2. Separately adjusting the subpool used pages counter for the portion that
>    was requested from the global pool.
> 
> In (1.), because the used pages counter had not yet been decremented for
> the global portion, the subpool observed an inflated used pages count. If
> the mount was configured with both a minimum size and a maximum size, this
> inflated count prevented the subpool from recognizing that usage fell below
> the minimum size guarantee.
> 
> As a result, the subpool failed to restore its reserved pages counter and
> instead returned that a global reservation should be dropped. The
> mount-time reservation is permanently destroyed, leaving global reservation
> counts depleted and causing an underflow when the filesystem is eventually
> unmounted.

Yeah, this sounds pretty bad. 

> Additionally, if concurrent threads modified subpool usage during the
> reservation attempt, calculating the rollback amount using stale local
> variables could cause global reservation counts to diverge.
> 
> Now that used pages are always tracked within the subpool, return the
> entire requested page count to the subpool in a single call. Global
> reservations are then adjusted using the difference between the
> reservations originally requested and those returned, fixing the issues
> described above.
> 
> Fixes: 1d3f9bb4c8af ("mm/hugetlb: restore failed global reservations to subpool")
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Cc: stable@vger.kernel.org

Thanks! LGTM,
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

With one nit below:

> ---
>  mm/hugetlb.c | 49 +++++++++++++++++++++++--------------------------
>  1 file changed, 23 insertions(+), 26 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e72e22f887478..9eb9f3442574c 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6676,12 +6676,14 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		struct vm_area_struct *vma,
>  		vma_flags_t vma_flags)
>  {
> -	long chg = -1, add = -1, spool_resv, gbl_resv;
> +	long chg = -1, add = -1;
>  	struct hstate *h = hstate_inode(inode);
>  	struct hugepage_subpool *spool = subpool_inode(inode);
>  	struct resv_map *resv_map;
>  	struct hugetlb_cgroup *h_cg = NULL;
> -	long gbl_reserve, regions_needed = 0;
> +	long regions_needed = 0;
> +	long gbl_resv_get;
> +	long gbl_resv_put;
>  	int err;
>  
>  	/* This should never happen */
> @@ -6756,9 +6758,9 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	 * the subpool has a minimum size, there may be some global
>  	 * reservations already in place (gbl_reserve).
>  	 */
> -	gbl_reserve = hugepage_subpool_get_pages(spool, chg);
> -	if (gbl_reserve < 0) {
> -		err = gbl_reserve;
> +	gbl_resv_get = hugepage_subpool_get_pages(spool, chg);
> +	if (gbl_resv_get < 0) {
> +		err = gbl_resv_get;
>  		goto out_uncharge_cgroup;
>  	}
>  
> @@ -6766,7 +6768,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	 * Check enough hugepages are available for the reservation.
>  	 * Hand the pages back to the subpool if there are not
>  	 */
> -	err = hugetlb_acct_memory(h, gbl_reserve);
> +	err = hugetlb_acct_memory(h, gbl_resv_get);
>  	if (err < 0)
>  		goto out_put_pages;
>  
> @@ -6785,7 +6787,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
>  
>  		if (unlikely(add < 0)) {
> -			hugetlb_acct_memory(h, -gbl_reserve);
> +			hugetlb_acct_memory(h, -gbl_resv_get);
>  			err = add;
>  			goto out_put_pages;
>  		} else if (unlikely(chg > add)) {
> @@ -6821,26 +6823,21 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	}
>  	return chg;
>  
> -out_put_pages:
> -	spool_resv = chg - gbl_reserve;
> -	if (spool_resv) {
> -		/* put sub pool's reservation back, chg - gbl_reserve */
> -		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
> -		/*
> -		 * subpool's reserved pages can not be put back due to race,
> -		 * return to hstate.
> -		 */
> -		hugetlb_acct_memory(h, -gbl_resv);
> -	}
> -	/* Restore used_hpages for pages that failed global reservation */
> -	if (gbl_reserve && spool) {
> -		unsigned long flags;
> + out_put_pages:

I'm not sure if this section warrants these two comment blocks anymore.
The logic is quite straightforward now that we don't have to worry about
managing the global / subpool reservations separately and rather just
simply do the subtraction to account the memory.

> +	/*
> +	 * Return all that was requested from the subpool, let subpool
> +	 * tell us the new number of reservations that need to be
> +	 * returned to the global pool.
> +	 */
> +	gbl_resv_put = hugepage_subpool_put_pages(spool, chg);
> +	/*
> +	 * There may be a difference between the number of
> +	 * reservations to consume and the number to restore now if
> +	 * there are multiple threads interacting with the subpool -
> +	 * restore the difference.
> +	 */
> +	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
>  
> -		spin_lock_irqsave(&spool->lock, flags);
> -		if (spool->max_hpages != -1)
> -			spool->used_hpages -= gbl_reserve;
> -		unlock_or_release_subpool(spool, flags);
> -	}
>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
>  					    chg * pages_per_huge_page(h), h_cg);
> 
> -- 
> 2.55.0.1007.g17ff1f9808-goog

