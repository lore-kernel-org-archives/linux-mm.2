Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57E39CCF2C0
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 17:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B3B6B0088; Fri, 16 Oct 2026 13:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC636B008A; Fri, 16 Oct 2026 13:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ABB26B008C; Fri, 16 Oct 2026 13:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B47B6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:48:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84BFEA81A2
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 17:48:40 +0000 (UTC)
X-FDA: 85329224400.27.39CC0CC
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id A410814000E
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 17:48:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mh96DurB;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792172918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1IH2nmRYbLcJJZrtxPMHJPqLJx8S+GWgBxUdUePLJH8=;
	b=LJohjvCm8d2ve/tV+sj6g7RNkpbkCV53zUbmF2sJcMwzsckpZRWY4f6Agn2bJc82Xf25FF
	s2b+F70FduykeQTZ4GHXm9sVXA1az4ysXx+Ao4WfzBboC/ykfTpTdmRQpKOx4pXwNSUQX9
	4WnDbpJqg3qkG42J/SBw2rXu+qcWL/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792172918;
	b=7EiLif0zYvX/ICekOr7k99PJLtcUTIx+xSTwpM0p74WX55nsu9K9iJ8VlqyNC7IEMZ0xdq
	7cisUqzxGJDP6YJPyzrmQ/hlwUgY/rAMGFShWKiY9o7s2/MAU9aUsn+Mh396NOjOqGmH6z
	us4q45mDP2YDh7giFAGOHqpzsNkyxDc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mh96DurB;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-4f48d91ba7dso149030b6e.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792172917; x=1792777717; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1IH2nmRYbLcJJZrtxPMHJPqLJx8S+GWgBxUdUePLJH8=;
        b=Mh96DurBsdR26WdIkboTadBXmF/e8Si87p6bkSvjBxIHuz+GFZ+RXK4B/MAI+H7unb
         ACjtkeV2qcq7S/4FA+NNCcAkdUk3h9XyNgHVDcqljNf1W165zsdQ6mqPTajXTGmvDmvO
         5hcN17cKpDmbeLdDmbJ8Gfs3oEQsOL1xvEntA/23neQNKl2gBuE94Ky8LmZ6VSgTVb2e
         8AnLvoP8LPqnVdT1QcOYj1pXTeF6LGwrM0CXSV+Quh3JavtTi+sTm/z0aG11d8PtMioK
         eTv8fSfYaxxsIAViLUkOPOFtOPTdyI4MywE5GjD+tRHPK9q/ZmWvIcJr6hy+GYL/uuFm
         thDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792172917; x=1792777717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1IH2nmRYbLcJJZrtxPMHJPqLJx8S+GWgBxUdUePLJH8=;
        b=xRHYtTEzsvOIZVKzjZGj1/vfhQaop6bKtuHVnEMRNJKoFWVUEb5F/aFnSyjNO5DapZ
         C1zZtG8ylDPdC9q9TvSxEqfz6ATkh6usm6q4BpnrCJUjpY8plxKO5kikhYzs7eK/l9hT
         ora5FgD4moqb3lHS2O6oagfhN+cx/ikF81n0IZwhME67nTU32dJIbRqSu32M8WT3AhQm
         3iBjjFZSt/4UfvslgOVMv6CKs8MqR88upio0Ry1ixvEEObxl7/yjaSf91D9tynJGigvq
         hfbkBOiy93cVrrAWgLdXnB1E+DhK0tEkPqs1wM2laVV58DigraPzfh9BDiF4EcML40Y1
         8t+Q==
X-Forwarded-Encrypted: i=1; AKwUvBwRsdVOqKAH4W4SxzQ4suFHMf7V55pITsui9G57ltWVmiELHPGy0+EzONeJadvFovEsH7NKIgkVhA==@kvack.org
X-Gm-Message-State: AFq9FYJZNXTqgjfN6K5qPhAPLlRJva7UTurvVBos05RW5vNVvAIxAfel
	vAcbaM65wuFDIyQ2ct3RRRUuMcMw/RJac9qt9rQbW3f3kxrD6OVmKaRG
X-Gm-Gg: AYBFou1xDRO73vipuB1S3XKcTkWpD7IPU0oYjyqhV6JojJNb80zohUb7CeOmPRh1wkC
	oa5rqWHc6dTw+uwj3tvn7H7JWWVd0rYMdnHYOWhyFw4EAXAwQqRQLIcez6dFsBdG76xXJhWlxe9
	aqssaCOWcwTcT7sXuwwSgYa9zydycanwg93d7AnjwTInIOTftgDQMKuomOQc0q/lzC6kGKvCiKa
	78CJs4nLh3C1ABThRtMUymZfv9Q1x6+AYvSdPqg/WF2LKWG5eNdmDXPzWMUHNQlAsb0bY3yq1AR
	AJsB25G+awiXn4hBPQJ8vDIrIoBnHYh06ShMxjTTUB986paKdJOQkXGRHuk0guhaQx+7OTsMn8t
	z6N2+DdTzz0V1gZGGoy2t043sL/knmiCAoRxTxB4x8ksuFJ/ID3a7Kmbxd5nGbZ/Y7R+KA3T8rm
	9LfktLRYfzyMU8wmDvK6xJYZHcJtPJxfQEijU5tO4cZ97GdE2o6fRl0sWLqwD7ZOVjixel0FnPD
	Q0gjhDnPlikmOBgCstUDN0juIOn
X-Received: by 2002:a05:6808:c172:b0:53b:11c7:2da0 with SMTP id 5614622812f47-53cd1cbc1a0mr285406b6e.21.1792172917484;
        Fri, 16 Oct 2026 10:48:37 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-5388c1654e9sm1901878b6e.8.2026.10.16.10.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 10:48:36 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip hugetlb cgroup v2 tests without the needed controllers
Date: Fri, 16 Oct 2026 10:48:34 -0700
Message-ID: <20261016174834.804715-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016-bug-selftests-mm-hugetlb-cgroup2-skip-v1-1-7c78883a67b4@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A410814000E
X-Rspamd-Server: rspam08
X-Stat-Signature: n5f7txdq55ajwmku564myxhfsfht4nm8
X-HE-Tag: 1792172918-331869
X-HE-Meta: U2FsdGVkX1/OSYrAa0dqAz/mLaUsq8ws+fUWM8URR2By+OhPsKeOBLhYGGcWGljDdcQIFK6TGV09K2IKaegra0AKW3vdx2PaN7OqgE7OZ5DL3lnWc/w7AAMnMb3EVD6yH3jipzInPku/ckmdkxUZPolrqtt+FpeQiCL09NzqfF6GHbaVEuEU9fIzksrHVy5DAfc2fk4y/ukiuQT0klzm0XnrXPc2RAMgCdTEgdlb+DqleagXmtmM/A94HhsKQvFRGPdebqjATfJ86THshUjD32NlhNNdgF/QV0kaGIfRE4gBlmsmJKB8WcpUKkGQtZUuEoNSPpPLzO4LR9NrMTMOeAiqezlK5OhKxHcYZQou9rLWjN6s1ewchWd19Z9r4AaL7+SpwWYyJFY9f5LEUBcuci0/B/t7EdozmduivdDSLudRMIbzvambkDKYz0jXeqVRCWTGYqhxM1ZCC1Wu979ybH0+kd2z2sJ27NneHo2pajc03rCb1CStLrVqcoFuwL5BE+//79KE60L8fiSbFt2WSiV2ERriEAPOqHNzwfLNTvbkirmg68zjertdOQrIWT64paDNLy4ufo/0b5kRu4u3ca2hSNdcxNQB9gd5zE7e5rzUm7FnODqhxpKNFfiRxv4XcOYIchcjEXDihM4vSM0xsGZZYAF3cBEuDTocoOV+Go03zkfM/8Emk238Cex0A0uDR7pAHABOwtZVEon2TheLMxE+/wiBI/ZRuIipvdqx8ML0GJkeuV8+1UDXj2Nh/b3g0z7TTYZLleHyhtqFyoNMZ+ShFd9kSK2tJcRfepiUhizeu+w++iM/f0Pmn18I5Ps9XL2Mf5h2BqAMArHl+QmYAoCmF6Vv6OsTnF5WqUnhqdi4x6duROPZ/v2h5qd8Dw2ByzladR9MSeI/l17kKDtdQCQGvb2rVOzogff3y4TyWtU3MabyOb+0sIKV6B/34ijoRyD0nOiJTEC9xo7S9ug
 lhyZp1pN
 IZ7ME6PpdkgvOtQuQ/OYQpGiad8ASB9h3jH9NZrRaYhCm8/8AbPHblBCT1HYvAoP6I+wpyG33zqTcIJvO5Q9zmTssDuS4Hr8pDAvcPnLyCtBWdIAUUTNAIAxRMFG3Q2BFbbVBE7vHjpRVouixz3eORnXrCYmy38zgX4+/273rYOrqhtA3XXte3EAK1mVMKKQ4zO6UvS4n83GqOEC0HjARp6QiM2X06x1Z8RVJ/j5yl8xNA7sE3eRTsatX7DxWGXq3G2J0OiUadrfupRi7zBVp1GueOpddiO8v0iQLSJZYAXMEbmxZ1o6vnS7FM0sovouAUxJYZKk7Nv6jXhS+dfd552Dqt0VjZWSnluySv8rJRxHklVNT1apyzFwUEsdgNTKjQYdwt6gWNwTno2IwtCROjmV0MnzozAIOGiJPXvoy6ivcwHOISYaUubbXsG9nW6an8mC2yn8QPPQs52JyC7jSLO/m9zqQXXoBOZ+Sa6WOOdGCF7EWjmYfAyDh1Bn0SauA5T8aMSrpvnyDTo81AcAyKfAjgzc6dru56f+MI383+hj7Vj7d2JgyQ6cjYI8/lX0S62eWkXlSY1Ig4a/quQWn0FoFnVLghz1r2368
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Oct 2026 20:54:48 +0800 Qiliang Yuan <odys.yuan@gmail.com> wrote:

> With -cgroup-v2, charge_reserved_hugetlb.sh and
> hugetlb_reparenting_test.sh mount a cgroup2 hierarchy on a temporary
> directory when none is mounted and enable the hugetlb controller
> (hugetlb_reparenting_test.sh also enables memory) in its
> cgroup.subtree_control.
> 
> On a system that still binds these controllers to cgroup v1, they are
> not available in the new hierarchy. Writing to cgroup.subtree_control
> fails with ENOENT, "set -e" aborts the script, the test is reported as
> failed, and the temporary cgroup2 mount is left behind.
> 
> Check cgroup.controllers first, and skip the test when a controller is
> missing, after unmounting the hierarchy and removing the directory the
> script created.
> 
> With hugetlb and memory bound to cgroup v1, per script:
> 
>                                 before      after
>   result                        fail        skip
>   cgroup2 mounts left behind       1           0
> 
> Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Hi Qiliang,

Thanks for the fixes. I think the problem you're describing is real and
the fix does address it. Sashiko raised a concern about failing tests
after this and leading to leaks [1].

At first I thought what Sashiko said made sense, but taking a step back
this SKIP path can be taken when we're mounted with v1, and the new
skip would prevent us from failing anyways so... I think it might
actually be OK, we probably can't reach the failure case once we skip.

( of course unless, I'm missing something ; -) )

LGTM!

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

[1] https://fb.workplace.com/photo/?fbid=2894459417496799&set=g.190352285091763

> ---
>  tools/testing/selftests/mm/charge_reserved_hugetlb.sh  |  8 ++++++++
>  tools/testing/selftests/mm/hugetlb_reparenting_test.sh | 10 ++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> index a1cfd3a349db6..65065b1377b24 100755
> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> @@ -39,6 +39,14 @@ if [[ $cgroup2 ]]; then
>      mount -t cgroup2 none $cgroup_path
>      do_umount=1
>    fi
> +  if ! grep -qw hugetlb $cgroup_path/cgroup.controllers; then
> +    echo "hugetlb controller not available in cgroup v2. Skipping..."
> +    if [[ $do_umount ]]; then
> +      umount $cgroup_path
> +      rmdir $cgroup_path
> +    fi
> +    exit $ksft_skip
> +  fi
>    echo "+hugetlb" >$cgroup_path/cgroup.subtree_control
>  else
>    cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
> diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
> index 95f517c3bd167..811912ae7d975 100755
> --- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
> +++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
> @@ -29,6 +29,16 @@ if [[ $cgroup2 ]]; then
>      mount -t cgroup2 none $CGROUP_ROOT
>      do_umount=1
>    fi
> +  for ctrl in hugetlb memory; do
> +    if ! grep -qw $ctrl $CGROUP_ROOT/cgroup.controllers; then
> +      echo "$ctrl controller not available in cgroup v2. Skipping..."
> +      if [[ $do_umount ]]; then
> +        umount $CGROUP_ROOT
> +        rmdir $CGROUP_ROOT
> +      fi
> +      exit $ksft_skip
> +    fi
> +  done
>    echo "+hugetlb +memory" >$CGROUP_ROOT/cgroup.subtree_control
>  else
>    CGROUP_ROOT=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
> 
> ---
> base-commit: 437a7e839def0f505277022622fc59a8b071d6cf
> change-id: 20261016-bug-selftests-mm-hugetlb-cgroup2-skip-7fc0316486f2
> 
> Best regards,
> -- 
> Qiliang Yuan <odys.yuan@gmail.com>

