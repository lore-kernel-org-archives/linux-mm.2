Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A5E606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 02:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=l9nqrC5g
Received: by kanga.kvack.org (Postfix)
	id 217C56B05BA; Mon, 23 Nov 2026 21:07:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EEB96B05BB; Mon, 23 Nov 2026 21:07:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDC76B05BC; Mon, 23 Nov 2026 21:07:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDD816B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:07:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D1AAA86FF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:07:28 +0000 (UTC)
X-FDA: 85468375776.27.A6D9A64
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 542801C0008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:07:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l9nqrC5g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795486046;
	b=oWWOJDO5AATRB+64le56WYz9OaDuOYcgUqWVdX1VRRW77kyR6Auy8LUqXo1902PLj/PdVk
	6m+WvVouI+ASJNVMIAOkltgQdPX2pySVy4LjCoynhNWHJyIFcVhKu/QPwg9XokcDsB0Lok
	B+6xLBYqT4QVo5deDTiBoM72qI+nhho=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795486046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nOEK6bBKHw6MpZVBmQwMq5VAH7bCtPDjb3P4ihpZ+U=;
	b=qEN9ZgBOCIllfl+g9Hb7f50tS0N317iG1hOvDMkobwAhzEucs+o+XuIGqDnuqfROT6BE6y
	N4qWvCb4CpLweR2gf7zpluIGZQ6rI2E5d54JdOErnXDGoslvNx0YB3iwqGfRtU9vFy5e2H
	gNVaFbRCcXq4WLWju35VC2K3Pfgj460=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l9nqrC5g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so34641525e9.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:07:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795486045; cv=none;
        d=google.com; s=arc-20260327;
        b=RjHy20bPaF/tqokox49QiOzbHYNC5Gt7J8K4djDgDJ8LXU3OwIJqo1WEf733l/gmFC
         gV6AksjKh7EPpRtm55f2XduF+R54a//5m6FfhDlEq5R+L1Q87QeR9aqS7yWKoY/RT6GW
         TVzJoBehcJFf0F5vJC3CwRqaZfSvaNw/s7weVFb5l0+gRdxIXH6yT2B7Dd/hcMIUFt3x
         5EX9ppvxAhVvHCR1O5jzAxRijWIcI+2Xy0C2hwnABRjGidkZgST6M12lsM3YqZErElmp
         YS0kJnfmfqUEkqHzY4ZkZbXA3SgDl/EUbksJL/EAEGmgXDiJVJ61vQu4hroguJI+1O0F
         FUPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/nOEK6bBKHw6MpZVBmQwMq5VAH7bCtPDjb3P4ihpZ+U=;
        fh=02uo3UiRzplpwy1WZR0NRyReRq7EXvXFofBULwm4tU4=;
        b=i1sqeg2UsAkHgtd89V9Kw3ZXn4xcpyScCE2bmT9J7sPht4EcYFfhuOsbOkIBIGu2fg
         2SjJxsAMd7sGDOuChQdx2ZTxQCr4TFF62d8Qr6VF0IQRoTY/VGKKUGwpn3/yTYwoDt1g
         iEwnaWYr3OuvbLxzRwb06h11s4EA2hkROqPT4PvmRczbImCIBH9mIcQS3jRJQlehaIBE
         VyZr+iZ3Kiqb7zKYZ2ycwQOSmEL1ThID6usAUwJ4+IwM1h5UXmrn/64wbckG/fESpm+e
         LnaTbLZ7yx9+zhxUHNNcxW81BOR1ULKFE21f+0K4Ss85yz/5+HUmGf7CHxtH1HPdkTjK
         4+ig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795486045; x=1796090845; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/nOEK6bBKHw6MpZVBmQwMq5VAH7bCtPDjb3P4ihpZ+U=;
        b=l9nqrC5ghArfXO4h70f3UTFt41JFiq+CYinAXKBmGjZq7v+Ofy0jhwJ2uOC2aNIJgs
         ITluABjKhWD0GybLwnZAp08wtdj7xetx9pghJWes23/DWYyU2VoCGzR0eZwGOYKGTZHY
         Z9DiopvKoxjzRdrqsX6SJUxDuuKZJSb5Bk9E4lzfO5g3tGIRLkoUVjLd+U7tpqa8gM/O
         ZgBL2jb1G8SOCHYJ0zIfcAPSVQZu41brjol8JBS/QpKSvMC7WPQHR4k0zPFX6GZ1oOli
         2lkXmsYlK6KAHojKgdrBIWblXp+FEACqLkDZNhnw99N8aKHoXzAVlIhHRdAsHF5lRUX4
         3yyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795486045; x=1796090845;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/nOEK6bBKHw6MpZVBmQwMq5VAH7bCtPDjb3P4ihpZ+U=;
        b=ZLvY87KrlvwoPxr1Sx9J/TFO9sl//nI3ti/B7L3bdLnxhZsOh2YXTc/wmAQ29V7KTY
         aBRXXs561r4QqNifP6v+I2oQFFobXngJW+nN+/wqRs/C9cDLRiaM98DPITtzbvo7WqGX
         QLjycfXsjhew08ynnK6s3LpPw8EQXl82qQ4MPIdoW6kgvZ/aJEiQ+CPzc9IS6TrQRO5D
         JH0hf39ALNK4IztsVVN7NWham3sh46HYa9fJRIzUueYCiHNMEqqu60EKZhidkvyjhS9U
         e9sAWrv0Mm4Ihia9dIk8a/NhqnKlLZutv2evKr+IWMD7k5GrNTmQ3IFHiP4ioDdbTWHC
         MzbQ==
X-Gm-Message-State: APuU4Z9O25SR5ausvwV9LROoMifc4V58+rzYLnPWDYqqWqFYuPvymS8A
	i0Erqmo+LRHVgOb03AZy0+5y48pOgYDpCgsTXTfOQ35U0MVtOFh9Qo/D/Q2OfWq7c/vfqNolifK
	3JV+UuVz6M5T6iA5P1eHxDrxFJbLP/BM=
X-Gm-Gg: AZFdTZfu1Z50XyeN3IHCwWqdiZ4Wk7ozb8rXchkhPzya5fdtXGn2AmD14bH51a/nGGN
	V6390KIF9g0LKQ1fMBNmGNrwpcOaL6djkkrj0O3Qm/MrDZwORxXIDIoqP4YsNcgyHK+gnV1N2Pd
	0VycyOCZ3iykqV2ZEsk9we4TvnJs+iF+FYsnEVbKfEWMMCnKtod9a87QOlDjGu3wXvSAawaTVkQ
	b7O1Yu76HiyCH0PUo+sziOq2NADLCjhFpQEzdfBfIeq3m+k1Dw0XMFZMMG4S4piSTnamj9Hk17P
	QORohbT9hium57neEbHztiTbY2+tHCZvVK5yt5XmWBdpJEKkz7iJHEQvduLcPEP+3QlvdRPSaAj
	tiFSFtpid5l+aGG5qRL96bvW5qbPBTx69GxYOH42dM/R9WuIbQ8lEOdxWTFOp0FvZDxBWsT9aas
	T3+DGPyCS90HCGHas1vPHvNy8gcubMR1LjTrNVv3mOGMnNt7x/68dIy7y1nydNE26MAccY4eNqm
	w==
X-Received: by 2002:a05:600c:a11:b0:4bb:69f2:87f7 with SMTP id
 5b1f17b1804b1-4bb88812c92mr280620945e9.18.1795486044232; Mon, 23 Nov 2026
 18:07:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com> <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 24 Nov 2026 10:07:12 +0800
X-Gm-Features: Aa3M54oR3KlpB0bkG1vPMJxZCKqEDSLHTpf01h2UkcgR_PoelqiPBgymN4KGxg8
Message-ID: <CAN_Opa-UaAUu=dOGmDAUiaU+3-s89Y+Y2krz6zGEsNLHB3k-Wg@mail.gmail.com>
Subject: Re: [PATCH v6 03/18] mm/memcontrol: avoid potential counter leak when
 reparenting local stats
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: gb7gt14ror95wefymnwyue4nmkwceeg1
X-Rspamd-Queue-Id: 542801C0008
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795486046-580719
X-HE-Meta: U2FsdGVkX196/aGjmsftYMOBKNmivgSx7+o83PoYdQsjCUi6oxt4/L/17ykN5XbG50PzHpbFt2tb6/m24PWPXt4c+rzuoZAOnfLlTJQKdQroUWtqKMkmzUMTuK7xagqqnzbwGE9PmLDd0HrprDcF5B1sHmoLL4ItmgkMsaAwfDd6NHdSDjxVwzthFXDDbv2rG7hDPpnFHIXA4sTwPl3l5yvgnHlEBAgkTP2PSX42B0hY8iGi7vn/2x+M4H9d3EimFKTH/I2QC4xHJa3dYt326Y1MdZQIWPNu3wmxpynB35IuleedLX4rF0HiQ8Di3ySKWftCVCBPXEVomorpkVm1572S+1Ux/LrPXaP6kY97wHKiqFLq+frU8bQoXbFQTXWkcoMBbkPlclKjQyNckgWLYtSOMTBoqvN7EtXeiMagWVB+RxwQ2SFah1vmLVUvTxTtCYsuINGtAF/ovGxTf5JmCNlHYjx+X931qkhpCMQQSgpzmxcXqeCXeXqp8bSH9oUqwiDKRZhRb93qRMVDrk1RyF6KQId3iyLfU6wJuR1a3oQgCOiLSNFbov5nUtRmbvFN9Bq1Ifu4hDeDvr65z+D2vFbOYp74EqhBeRLgwO1IQHwjjTahxF1he5S0urS9CSeB5g3qxjEkza2zhdm/4go4e0BZOVrCzLE/FieZKi8/Ds4QpwHLJkJF/MUzWfxgYS8/xa9nKe0u/yVwO3Sil705EcSnsIGOafVDlpL+MqLbd2k5kFwzxolVuHr9rpoDQarpn30tVwZCo3YRVyVSPAqNDaK8SdP5l2xSfL9mCst1+gLaFxZn22l9kKHaE7sIl4sTQUSG3rRfP6989ipq9kvVpPM6rTKx3746wZub6YYJp7ZTVp3l0xDT41q//a1QeSpvHRg6uDqAWe/uv7xmp9KOA/mcCjehBFUsFFkMbOHVFNl7klzk1LmWoFpgYdmKBNrerjoGwHZnDtQTPLXaC9V
 1niFLfPB
 4FN8eMZizt0/TxC35+tqDgO5zsN7l7972eVH90gNWZUCq4ALht33iy/XVjJTrbr0hs4oEM6OAmQFvAOIZlQT08m0eOjCrfmIgO+kqTxFxuyJ1xnMSUWJSHDkfpQxxIRGvmBfdSM56139ONvXeSNm9SIs6Nct82LU4d5glhnMmn/4ML0CvLQwfaJ7/7HT7UeLsbnfJtfwM6PORq19HyFEazZoPZf4LGoUzwwxCaPFonYe1KhnASyVjabl7kHeJzvXNSHW3gn12Ybv7sv2Rn+n+OS1jk/19fBi2z4lT0gJF4+wOmLLTGcwXFaYOnSP6qQCYwCbL2uCv6jEDOwp6TYD5RWliG/0WucW1wJrwHx+vjTa71GHNRGIaN5v2XHoQ3MwtPQjBE6Guj33BBgi1Z+5FQoXFi0v0b/JzXAtlMDBrHgx/jN4rVRf33J0ekmU8oFGP+BmguVQI3OZDNqkUd+UcqybHnAz1cPybzuxCnjkD/9Ztlwvt9ybbWxQbMycMv+e6viw4F074EKe9HlR8RuDxQYZooltRk6wJxXZZbSKMbexBUhYl8LebG+4Iwp4IgLUWKT5d0OVulqlY97x4RxHmv/EMR/Ui00q9crjmvHms4BOrA2cUrT7gkSPpcotXLarUncjXt9x+UWM7fUXo4EDhL683j+rz+Ixx5d0S38L6+V/jmZFpQ+5HoODmZ80HwBf3zj15CzjTxInODRr80zYznIZRKvKthoFJU/byznUrm5aivmT3yfLxC/bmfYWZQjPCrKaOkGLnnVLtnlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 2:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> lruvec_page_state_local() clamps negative values to zero on SMP.  That
> is right for readers reporting page counts, but can be wrong for
> reparenting once MGLRU updates the counters without the lruvec lock.
>
> Reparenting runs after the forced stats flush, so a negative is a real
> balance that has to move to the parent, not be discarded. We will
> introduce lockless MGLRU promotion which may cause following problem:
>
>  1. A refs CAS on a folio on the child's lruvec moves it from
>     inactive to active, and its active/inactive counter update follows
>     as a separate step.
>
>  2. A concurrent isolation of the folio reads the folio as active,
>     debits the child's NR_ACTIVE_* by delta before CSS_DYING is visible
>     to it.
>
>  3. The child is killed, and the two __update_lru_size() calls from
>     step 1 land on the parent: NR_INACTIVE_* -delta, then NR_ACTIVE_*
>     +delta.
>
> The child is left with NR_ACTIVE_* -delta while the parent holds the
> matching +delta, and reparenting the child's raw value is what cancels
> the parent's credit.  However, if the child happens to hold few enough
> folios for that counter to be negative, lruvec_page_state_local() clamps
> the child's negative to zero, which drops the debit instead, so the
> parent keeps NR_ACTIVE_* overcounted by delta, and its active + inactive
> total overcounted as well, permanently: the child's local counters are
> gone once reparenting is done.
>
> So use a raw signed helper and reparent with that.  Ordinary readers
> still keep the clamp.
>
> Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9=
Sy_DBC4CLkWjNLzDWKw@mail.gmail.com/
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memcontrol.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 091401cecf39..3f551e2e3206 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -562,11 +562,10 @@ unsigned long lruvec_page_state_monotonic(const str=
uct lruvec *lruvec,
>         return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
>  }
>
> -unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
> +static long __lruvec_page_state_local(const struct lruvec *lruvec,
>                                       enum node_stat_item idx)
>  {
>         const struct mem_cgroup_per_node *pn;
> -       long x;
>         int i;
>
>         if (mem_cgroup_disabled())
> @@ -577,7 +576,14 @@ unsigned long lruvec_page_state_local(const struct l=
ruvec *lruvec,
>                 return 0;
>
>         pn =3D container_of_const(lruvec, struct mem_cgroup_per_node, lru=
vec);
> -       x =3D READ_ONCE(pn->lruvec_stats->state_local[i]);
> +       return READ_ONCE(pn->lruvec_stats->state_local[i]);
> +}
> +
> +unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
> +                                     enum node_stat_item idx)
> +{
> +       long x =3D __lruvec_page_state_local(lruvec, idx);
> +
>  #ifdef CONFIG_SMP
>         if (x < 0)
>                 x =3D 0;
> @@ -595,7 +601,8 @@ void reparent_memcg_lruvec_state_local(struct mem_cgr=
oup *memcg,
>
>         for_each_node(nid) {
>                 struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, NODE_D=
ATA(nid));
> -               unsigned long value =3D lruvec_page_state_local(lruvec, i=
dx);
> +               /* Reparent the raw value: the clamp drops the child's de=
bit. */
> +               long value =3D __lruvec_page_state_local(lruvec, idx);
>
>                 __mod_memcg_lruvec_state(memcg, nid, idx, -value);
>                 __mod_memcg_lruvec_state(parent, nid, idx, value);
>
> --
> 2.56.1
>
>

Thanks for following up, Kairui. Reparenting the raw signed count
fixes the case I had in mind. I also checked the clear_refs and
workingset changes in v6. Both look good to me.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

