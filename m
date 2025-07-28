Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7286C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 13:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759976B0092; Mon, 28 Jul 2025 09:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70AAB6B0093; Mon, 28 Jul 2025 09:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9426B0095; Mon, 28 Jul 2025 09:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AB156B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:06:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 072AA10EF42
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:06:44 +0000 (UTC)
X-FDA: 83713697928.17.4F3E545
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id A9D8740016
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:06:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753708002; a=rsa-sha256;
	cv=none;
	b=sDrdllxWHbNEVjliPsP/3Dv7Ka0islM47TNGAKaLlXrIW3YxtPZmg2dFByCOO+NNERDXVy
	1EHKjWLUF3eUmvZQzjjSA0PyqGAvqEH4T3R/BPhhmSoRgeuWX+cMfVYntoszmVM68fmq2l
	5h/Kq9j96J7Hq2yTc6qe2K8N9tUDa54=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753708002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/QC5Uml2RzEUPlWKdwR99j7fu1LpzpTRb5ePH6MzOdg=;
	b=Wa74myB4F7h/emJZY7Hu/UblZkTM2PukM/3Ti84ve8R0aar4t4KLLeB8FlvpQmsBaguXXa
	KjcE//YhdfexK62B9UKs9vgGDVMlsu5Gs4+D8K/E1uK5vtj1imgIqKOcZwn+6bV6kH1KD+
	VFHG6koR9fTgg7LFQJY4biyRsys3BfM=
X-UUID: aff7d8466bb311f0b29709d653e92f7d-20250728
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:65580000-cbad-4731-8dc5-6e4149e6dd64,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:7a757c635182a2bde344434a80c9e0fe,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: aff7d8466bb311f0b29709d653e92f7d-20250728
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1996137064; Mon, 28 Jul 2025 21:06:34 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 1F3B3E008FA4;
	Mon, 28 Jul 2025 21:06:34 +0800 (CST)
X-ns-mid: postfix-688775D9-9540941
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 70404E008FA2;
	Mon, 28 Jul 2025 21:06:28 +0800 (CST)
Message-ID: <fa7485e4-a3d9-45ef-a0f5-6a3b9dd12f93@kylinos.cn>
Date: Mon, 28 Jul 2025 21:06:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] PM: Optionally block user fork during freeze to
 improve performance
To: David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>, rafael@kernel.org,
 len.brown@intel.com, pavel@kernel.org, kees@kernel.org, mingo@redhat.com,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250606062502.19607-1-zhangzihuan@kylinos.cn>
 <20250606082244.GL30486@noisy.programming.kicks-ass.net>
 <83513599-e007-4d07-ac28-386bc5c7552d@kylinos.cn>
 <cd548b13-620e-4df5-9901-1702f904d470@redhat.com>
 <a4370ebc-b1ce-46ba-b3a4-cb628125d7d0@kylinos.cn>
 <aEvNqY5piB02l20T@tiehlicka>
 <ee1de994-e59f-4c6c-96f3-66056b002889@kylinos.cn>
 <775aaf10-3d19-4d5a-bf2b-703211166be4@redhat.com>
 <7d70334a-2e0a-4d1e-b4d0-64d0e3aa5439@kylinos.cn>
 <345a04ad-cf25-4af5-802a-bc8826d37b19@redhat.com>
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <345a04ad-cf25-4af5-802a-bc8826d37b19@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A9D8740016
X-Stat-Signature: ix1xibc4pgxc556375t9u5ytu6hkakgd
X-HE-Tag: 1753708000-40609
X-HE-Meta: U2FsdGVkX19jIhhCJ+BQc6A0tAk8Tm3N6+Vq1/CV/3ryLYdVo6UGVGKU9Ll+mPNJwdxAqp6p9I29S7UYR82qGghl+cnU2prqBtEcp3LRMw5uqZ0j0QQBmjucroB+6mgLmaa5wP7Ox8Qdxlb+pqBtJAJl45EZyUJNaoBBYv53vNzyUJGCu2o2uAyYrDIcQekmZNfNnJEHQdEsaZ6tZMDxlwkv6HvF3d/+ghg4dGTfGYbOA395sCJRLtJ0uW67rji2QdJXsNRUyV+oT/tu9kl7/7wefELf/5L82WrO+XcQF5n7y+Mg+bson5yapaRu/24IbxFym71+QIxXrWUmWSkUffY66aSOkXtXVIZi9OEHH+/SLcmYO/U9WLoro9uhZVLFv3Ede52w6q+vQBNiBv1KBozG1gGg9NVvhcRE0tbNW1ckG8P9yoePtpNmiEpWooOLfiU7y6JMXpkDOGrcO7ZKupwt/wbsl9dEQkLecLiuozcONEQYQjTtyRAi7zWVdilsFz1+81qXtISAubl7Yo4IEnPgCV+6WxJCKinIAVkWw2bCaA6i6H7fqjHmleHgN2CIlPxWAQK0vtKsKFn63Qhj0d10F3Ht0OkfVvVJ+U2yybkd9idmlmCDa+BnDF8tb6BPDMLIZhAZqBU0VZ7fEQj4FXtFtRbw27nODfCSwO+MNPXre5Qfa/2PWfAdauEWA/72C1UwBBS5iaq8s5irwDinW61AU4D2sHlgQrga6pnjA2tUvTUn5Et/z31ab2m6Sovx+FaPYPgeYzHJwvoZhEH+2EdYEaTkP2r4Z4efO+Im5GpPhCIo9k4FcXpeYxNYWfhwO47ShMMv81su9wOOJge6lLg6Ie9t2zRpkyQf4dlx6NW33pcwm9cK9uq60fNDAD1eGWYFesSoDD+EIYXNbnwzLE9Z7gby+I8CVkOoFIiRZn381H114EgMHVk60CuwzvrXQkjrrPFAxUcA77KaNjm
 3FpFVVop
 Stl0JBpnuYcUxbVhATSPLfLHHG4FAJPHlcpvzJyknebn3e+I2iGGFRBlnzSjdYX7RgDcyaQ34BeJgk2N2sFdOrHnOBfCxJizocXGX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2025/6/18 19:54, David Hildenbrand =E5=86=99=E9=81=93:
> On 18.06.25 13:30, Zihuan Zhang wrote:
>> Hi David,
>>
>> =E5=9C=A8 2025/6/16 15:45, David Hildenbrand =E5=86=99=E9=81=93:
>>>
>>>>> [...]
>>>> In our test scenario, although new processes can indeed be created
>>>> during the usleep_range() intervals between freeze iterations, it=E2=
=80=99s
>>>> actually difficult to make the freezer fail outright. This is becaus=
e
>>>> user processes are forcibly frozen: when they return to user space a=
nd
>>>> check for pending signals, they enter try_to_freeze() and transition
>>>> into the refrigerator.
>>>>
>>>> However, since the scheduler is fair by design, it gives both newly
>>>> forked tasks and yet-to-be-frozen tasks a chance to run. This
>>>> competition for CPU time can slightly delay the overall freeze=20
>>>> process.
>>>> While this typically doesn=E2=80=99t lead to failure, it does cause =
more=20
>>>> retries
>>>> than necessary, especially under CPU pressure.
>>>
>>> I think that goes back to my original comment: why are we even
>>> allowing fork children to run at all when we are currently freezing
>>> all tasks?
>>>
>>> I would imagine that try_to_freeze_tasks() should force any new
>>> processes (forked children) to start in the frozen state directly and
>>> not get scheduled in the first place.
>>>
>> Thanks again for your comments and suggestion.
>>
>> We understand the motivation behind your idea: ideally, newly forked
>> tasks during freezing should either be immediately frozen or prevented
>> from running at all, to avoid unnecessary retries and delays. That mak=
es
>> perfect sense.
>>
>> However, implementing this seems non-trivial under the current freezer
>> model, as it relies on voluntary transitions and lacks a mechanism to
>> block forked children from being scheduled.
>>
>> Any insights or pointers would be greatly appreciated.
>
> I'm afraid I can't provide too much guidance on scheduler logic.
>
> Apparently we have this freezer_active global that forces existing=20
> frozen pages to enter the freezing_slow_path().
>
> There, we perform multiple checks, including "pm_freezing &&=20
> !(p->flags & PF_KTHREAD)".
>
> I would have thought that we would want to make fork()/clone()=20
> children while freezing also result in freezing_slow_path()=3D=3Dtrue, =
and=20
> stop them from getting scheduled in the first place.
>
> Again, no scheduler expert, but that's something I would look into.
>
We=E2=80=99re currently working on a new freeze priority mechanism, which=
 allows=20
the freezer to freeze user processes in layers rather than treating all=20
tasks equally.

With our priority-based model, we can ensure that key processes are=20
frozen in the correct order to avoid this class of problems entirely. I=20
believe this approach will address the issue in a more robust and=20
general way.

I=E2=80=99ll share the patchset soon for feedback after serval weeks.




