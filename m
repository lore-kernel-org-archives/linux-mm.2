Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A02606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 16:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=qMQnfBDi
Received: by kanga.kvack.org (Postfix)
	id 39A986B0749; Wed, 21 Oct 2026 12:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3248F6B074A; Wed, 21 Oct 2026 12:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC506B074B; Wed, 21 Oct 2026 12:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEA016B0749
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:59:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 555EFC0248
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:59:26 +0000 (UTC)
X-FDA: 85347244332.07.915B2BE
Received: from sonic305-27.consmr.mail.ne1.yahoo.com (sonic305-27.consmr.mail.ne1.yahoo.com [66.163.185.153])
	by imf02.hostedemail.com (Postfix) with ESMTP id 41FDD80006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:59:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=yahoo.com header.s=s2048 header.b=qMQnfBDi;
	dmarc=pass (policy=none) header.from=schaufler-ca.com;
	spf=pass (imf02.hostedemail.com: domain of casey@schaufler-ca.com designates 66.163.185.153 as permitted sender) smtp.mailfrom=casey@schaufler-ca.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792601964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kah1CZOWcJGjnZrMGrCQ0VvDoaKkFOiqXfkmX5BbHr8=;
	b=dDbLOlTWWufUetm50M7Bz1BaK108iJdrPsK09/5ExDSrk/qU7o+7JKfz5vyfnMB4pP7X8q
	XcDRPsSiH3OPl0U+pdct9ZrNgWLHZhSEw1gfRdwpioYqUh3ccATlY7mEEqTHwwxOcPhvnW
	R+S6SQu+mnxK1NX5rHeBAFGJWqsjJhc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=yahoo.com header.s=s2048 header.b=qMQnfBDi;
	dmarc=pass (policy=none) header.from=schaufler-ca.com;
	spf=pass (imf02.hostedemail.com: domain of casey@schaufler-ca.com designates 66.163.185.153 as permitted sender) smtp.mailfrom=casey@schaufler-ca.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792601964;
	b=Ug3ygzDh0sOJNRE2STEY0UebxqDHSQNh30qDKeI+NAlBs3AIxMSErV/iMoTUB43yaT8l80
	SCQorz/InamDQ51Y+q5+XlMKdYno1Dsz0GlluZVO1Lx3oD5rSA5dGG4F6UUoTDyr1IOEkr
	rxCMoyNZFVdGE4QCVawO3gMeujtsN/E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1792601961; bh=kah1CZOWcJGjnZrMGrCQ0VvDoaKkFOiqXfkmX5BbHr8=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=qMQnfBDia3rzQvnbPH1rRInnCtXPAP7wZxUN69jQdmj3/feNJUurhHOMBlYlDz6noeiMmcDw8D3O4VsFGFMc68sBU7kW9UooBIYSAnN7sc8q3CgvnBl6SlrGNLvn7X4DjI+bv+1/2OFC1fgQpEobvfQx3Or0w1h7HgHC2zANGhnkDTNdehZRGNSM1vY3+aw5PHGXjvaNz7toI9rFfbZ2qV0WaNHY8pYG+ddiJ+VuwMU2+a63TXX+xbcSlJxQUSFdKWWayhUQB0h5zMg4Ry2fjOtSIJ7w2qFcn5BK5OkWXtbSjDELJvZ5JhzuDfy9VaDrWDF0kYau8YoH/wgolRUgzg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1792601961; bh=9PleWcYR8e2xn5hY7aHEeHxiIX60ZkmF9ZqouUvxMwn=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=BiFURWH2inSJa7DFCFcZJwzBVBrLuIxN0cdXYla1/FI4QIgnjpsEUnivZv112EPYGJnvKMXlWURjSGrxzegCZc6npQ8F8GiIkCMZVHdqD/+vr/67no8e8pPnQFvpXgYs19P/40Y+1rFyltkA2GxCcMRtn3fBmBSZ1yrvhkz1/K5ccD2RgnOUD5ppzYTYrRHoNMfuGYU3z57cFbJXfZgehmzAs6YmxbKSKO4m/l89JzNp/t2GQP3OSvDH4hedXG4DzZC1LcRgTsNN3VILCvMirXj+L1Hx9eLf3/UbEFkKx+58zNXuLh5W5G+/bZFUkKTTPNqqVqyEJJ2flRpRVQZ8JQ==
X-YMail-OSG: LCA5RiIVM1mFSCBMSGrvZTC8G7qdX_QeTDLQPq11oZ4Qs99RUpqqME0f_B_mElZ
 l6.tE9BmQSqjGHTZGbu5..066d1.QaQxFtWQhzSbQaXqKv9BGyIywqx2ethhepd5Le6FRRzaBgvT
 IA5kBQUdG3bOvzIV8Mdg3nBI_l1Vw6U2HLt6PO4KsNeIahFcgcofhYolkU_geZBbhLYIVAuC407Y
 HvbLmP_rwk5D5uBG9Ck5xRyetpLcpQKf7QbYsUtP.8bAQyx5Q_DKSiBUK9W77Zo1DwP2joi6nKId
 azCcKYp3M3lk7toaR7qnZ3jmWyj0ZHcrPeGPdva5QynQCq7tx4Wf3_uUjq_gO03SL1p4T99TNaa0
 sIDF3HL.BTRJJ9wG4tWNiGQdpFQfzXDg0ZLx7ReBnXGGuaGQM.7Mf6WDB7BOPA2rFMF.jRlOy.PF
 YkK8ScMuhQFMupMZzQI9r0jBzRPPvY.AP2NJ2Bm_uVycbuEGE3k11XU2g_x_1vnZVgoQ70hoshl5
 c7DtDzSnTv8o3modT6ZdSdrlcQul8Ml4gUOdlQfZwJ5NplHl9tEgyua5GAx8vvnlM2XAPrFW5CjL
 hWFjiv0R_G90utoxLyOtsCsynU1DK0YWmKR0aHelhshp9Ik92VJfRLjPAapXvR1ZrT0z1LEb7kRc
 5E317PXytnV8Jp7oYSDMdHjrJZUMw_vdyRU5ecKfsC7Xmb0bgD6JRw9EH9XOLs5PXcvAZodtbQkK
 4FoVtN.J9jgRMVbRgqjsudq2xYgpq6ntEtCqoT0TSwWD8nORuSBy.3C1343SDhg7Y7H9woZcCjj4
 j3ym21r4ATvK8faXoConUY68Ct2M_v0k0r9ZafLWBaDmRxVHvMTean.IKYrqq8XvN5Ig7xk129vG
 HILg1N144lXulDiXI1UYiZKVOKuW9JXGXWk0bvw1wzqGUi.oLuG2IgPMuBvtGQgmXDrRsGkS8oKe
 wjjXUU5xri6qnDyGVb1EY0.4H6raaNgpLrBwb.spG0hbAJPhfSxgBns.YZpiVOH8F9yDWkogQ3CF
 Oc5sfT3VLkLCxu1.EfkYQsI1WbW6xjmcpPVawbpHSyX98Nf5fM1_1QD3MuUmaC6ehO55_yB9l.z6
 Re9XZczDI_95HTzLLfNiOIEI3qT.soQ5bTtLQsMcJk03ETZsfAyKc0ylSYplHM9e_iMNHjUPY0uM
 EVbxOX8_hf2rgWLMEawC9ES5oz9t7CFtGXLiNes2Jpev5e43XzLY28mQt6l.F5mw84Gx8D9rgKwt
 Hrxag5HrDqh0Pe5t8.HTz45sXVQqt7sq_0pak4Xvya6Ztzesc0XT9EfCuPq_9gjHBG2Pp0BZUPvM
 7GjTYYNV9nGProtYkPF70ABSabjDdYOOHJco2neGyV28BQm6flQyvfXC2DsXLUIA8MWd9iaJcXIO
 3snVF99t2NwPTCF825eJhnIjdPTxQSoACtUtGyZ7qj5lR9ck1wpavjNaU2YxsOlnJh9MPANCcWzG
 grDz5WAW3VtLpPUC.wjvvz.iYd_aGqnrQWtIBnB0.FvtevthzWTMu5UpFIboJfDL5qfkneyaX24c
 uKj7xwMxTsK03KM8wvImj5ZuXnRozbbeU0HZpaPElt_QyVpuv4JYRMcHm__iCAo.rOj7g07TUkcH
 dEBlnRsD0E7s3MHPqx8C6WN21R6vsy5X2ZbDXxbh1C2ZmRKkSadL0QqxNRcJ9e46FnF.1PdafapW
 9AyUruX88Y4VUp1EPcuU.34N7QRKobQ7N98TjaYtOsBV0cTF3oHfD3J8pCQ27V22nsqVoFaddqgy
 JdDWkDKsocrnRJn7l01fOgJovbUa3sRWC2YuDIEEHtlkEO8VFw18XzuC30JLHXC98rj5r0lPR5g5
 D7gOW3y_hng_S.bbgnIDbGwv3xuA0Vv_eawLObYrhnEBms1PDU7i28IufTfcYJqckL7WKnh3psBi
 0VJ_5yABobEbzCFT6Xv9kIJNCui0UgR4VSpUx1CQtqG12WwTIFsnXGRfQg0xZE.LVcMFPMTGrFQ8
 aI982JBxQoWpacnVh3SKkzmojx1r04A6WI7.AZTv1YnHu8aoZTDWiQz_aqeGisA9GNb2BiB4SCaA
 pqB0t7kUCPvh0Ic8i.cszWuYosiBbEy.dyTUNI_Hd5QZbcp3xMThX9eqxEpJR3Prooszu0RgBUWu
 gRUeji98ltpVfBZgpC8HqsDSaSwYhH7Qx5RS2ZcQrpV3PlazGfrWnwNktaL6IvnpxsZ84ZIk_q45
 N2vKv5blDyT86KvsV_F7z8m7hnVaLFROlo.sESARl5kSsfbP3jG1rMz_px8rm
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: e7a1fa82-6891-4739-95f8-4de5b52417d8
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Wed, 21 Oct 2026 16:59:21 +0000
Received: by hermes--production-gq1-fd7994565-ftb5j (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 9de1ca094d9183894955e8f06f19efe4;
          Wed, 21 Oct 2026 16:59:17 +0000 (UTC)
Message-ID: <0aeea80c-e3ac-4b6f-b1c9-ef18ea2964b3@schaufler-ca.com>
Date: Wed, 21 Oct 2026 09:59:15 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next 11/14] smack: specify SLAB_MAY_ACCOUNT for
 smack_rule cache
To: "Harry Yoo (Meta)" <harry@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>,
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module@vger.kernel.org,
 Casey Schaufler <casey@schaufler-ca.com>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
 <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-11-096800aa3330@kernel.org>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-11-096800aa3330@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.26740 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41FDD80006
X-Stat-Signature: 8btt1bjyozz5b3mdb4ekja3g6s6mc835
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792601964-676040
X-HE-Meta: U2FsdGVkX18VxmpgpquiJ4amEu2NErorS10A+f3J1FACnv0Q30pW/S9EMrK5s7v8jOe/9zurJrlO5g01sxnfCrEGjgRHfeOL8H3auoH5j0G+U9yNeVpfaDCBAoxWULzBttjqxx4Dy1zaaCdv9r5cmjboOLdj/DhZkHcbXoSx7Z6jGutz8Cwjzb2yoVAC62Arvl2y74ktty/CCJdl36SrC85e5NKG3AjiALpLK1ClxvTpsKVJJNu6oZwjo64tnLQaSLxZ7wzAC2R/pkR2J2PbmCeYNz7Ze43rTi3kfJbuljeu9GLKxmNuK/Zj60dWMZyl1KUf1AdA2qTRKk+CZNhXCDMM5hUdK8RUXXGWJloWKmUskRgNxEBobI3k8rveL6upPk1X+wHxFsJswJqySm0vjnisDeyo69tC4BeT3uyA/gLe+DISkYBSbzb0qC9EZR++FXfhQ9YP42oiF4XZmyOPvdBwTeVAW59jnh7R4FLJoLsIti+iOOc/pkH/azIF44qJdIPmfWSwKalZNe+f+rXKDU6LSuoUT4Y4fGjRnE8ltotQnG8kIbihMZFeZws863Ymi/FCusikEM0lcMpSvfxvhMbZ6A43sGq+2IxDyB01c3RmDse5ZdMY1yP0tx77BTW39/i1K4U85g1JFf/g6AhlKPrUgGmNUL7W+4Yw+AuvW6bDs0LiYnEDuegrXpmEzFMGYKp3u+2olOQY4T1FnbvLkmJDrTemrC+SPCvvgELzFVbeQwct1p/qD5Psjt1D8+SVdxUEz3vda7HRTvDXh7vp8/a9fKlRuWzGNA5Fmns0Vzi0aKMYAdEiw7KupOFQeyTE4OYnA06gzUzwUw7It6M/XcdBaTyOn3VjAxfUEbgJsn1J4eSWco1BfccpQxjwZ1McdqQWfS7IbrxD0+EvFvppNA0joA0SMEj/0umwQhICLmNUpVit6sZ+62sddUKJho765V/hebY8ZJBpS3N2M3C
 zEzEfn9h
 CQPyZeMM0ndW6edzr2SWfGfXR8+dxTSYQchEORCnsr8USMQf9uqGvqLhny025ICK1yDKtQ8GqdkhqfSQ/gPLLpEu3ElyMZjtp9xdCQLszkvdkCNBk4Z2NROeLe8LDauq1Gzw6L2nFzIBKeTIy2aoBoMrBiLEYKRwoLXxmH5Ea49H/5HyM5hwOmhcdJAdHdxLOcckkHFTSaYVTVdWhSEJ1dtStY1mjoh562+NgaAZfR//x54LC7rhjO7rorWB0nAMWSEDlT02sclSzcK1lFD3YMaNxaisV8JBVN4k3sosxXIs4KHj84GlYQdZn7ce/v6B9hRv8IXySk/OtuRdH+zD1t0oRRePdS4YqLk2lZE8I7c6jmjinXwnftOyNQXrMdFNHVscNQUUdxmAJOoUHeOXTTcqDQozxT++iAg5/WfLb75rL8yEr7ViJfZEi6Zw3cA85hUNzh/2c+wQmAB4Q6AmGfXMWZTmxLGEVnW7kgbkDxEx8sDa9XnzQFBbO2AkJESlVyak9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/2026 4:46 AM, Harry Yoo (Meta) wrote:
> smk_copy_rules() allocates rules with the gfp passed from
> security_prepare_creds(), which is GFP_KERNEL_ACCOUNT. Specify
> SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
> __GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.
>
> Path: fork() -> copy_creds() -> prepare_creds()
>   -> security_prepare_creds(GFP_KERNEL_ACCOUNT) -> smack_cred_prepare()
>   -> smk_copy_rules() -> kmem_cache_zalloc(smack_rule_cache)
>
> Assisted-by: LLM
> Cc: Casey Schaufler <casey@schaufler-ca.com>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: linux-security-module@vger.kernel.org
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

How was this change tested?

> ---
>  security/smack/smack_lsm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 8e88ac65fd7f..8a802578ac29 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -5352,7 +5352,7 @@ static __init int smack_init(void)
>  	struct cred *cred = (struct cred *) current->cred;
>  	struct task_smack *tsp;
>  
> -	smack_rule_cache = KMEM_CACHE(smack_rule, 0);
> +	smack_rule_cache = KMEM_CACHE(smack_rule, SLAB_MAY_ACCOUNT);
>  	if (!smack_rule_cache)
>  		return -ENOMEM;
>  
>

