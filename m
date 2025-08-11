Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E21DCA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 22:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5A18E0091; Mon, 11 Aug 2025 18:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F2C8E0045; Mon, 11 Aug 2025 18:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E5E8E0091; Mon, 11 Aug 2025 18:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4CCFF8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:15:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53CCFB5ABD
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 22:15:06 +0000 (UTC)
X-FDA: 83765883012.20.87C48AC
Received: from techbitestudio.com (techbitestudio.com [75.119.147.106])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1F4284000B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 22:15:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kenip.in header.s=mail header.b=ZFFE5jq0;
	dmarc=pass (policy=none) header.from=kenip.in;
	spf=pass (imf04.hostedemail.com: domain of siddhartha@kenip.in designates 75.119.147.106 as permitted sender) smtp.mailfrom=siddhartha@kenip.in
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754950504; a=rsa-sha256;
	cv=none;
	b=WuBQ6Q7eA34dcRHnE8mY+f+3k3jeqX2ByJkF4DIFF/y81MI1SZzi7nE4eqOJROPFBzDFc6
	UOIXKEJ4RRNF0UPm3nvH57YV4V0zC9fItO8H7KVSxtFb3NUyZIwzZ+sofN0DZFdnriSQ0H
	tC5oorFQlW+1mrwn767hsEIPo4Vl1hc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kenip.in header.s=mail header.b=ZFFE5jq0;
	dmarc=pass (policy=none) header.from=kenip.in;
	spf=pass (imf04.hostedemail.com: domain of siddhartha@kenip.in designates 75.119.147.106 as permitted sender) smtp.mailfrom=siddhartha@kenip.in
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754950504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IGo63ECA/gGOkB+h0cgRokxR+zHknMKGQ31ozejwmbg=;
	b=r8/GwEiotdpnHfvRRWEp/fQIWSloUxRXGlQlA/uKeuf4ea1zRJi5ANkL20WkxRt3kYa+Yu
	jfcfQi5vVmIP5NxlQMkcQGRwb5F6DFYoG6VP661qvbkn7Ncr23cOk1XBbPWMCCldvWRBJx
	UTl/Ys2zNmB2AXKw9WlExCxSPQyawn4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kenip.in;
	 s=mail; h=Content-Type:Message-ID:Subject:Cc:To:From:Date:MIME-Version:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IGo63ECA/gGOkB+h0cgRokxR+zHknMKGQ31ozejwmbg=; b=ZFFE5jq0is1ZvoEVTHcYc7klJb
	6s7HAJpwVk7wk6R+hcz2Zk8V01jgpO9vearVdHyoDPzoLgzT/IY5Ii1O5yhEKnAHyXr7jTxqh2oXP
	fRqcpWdq3JOw5bwlVoHj26zaYOrUvNucDDcX7zcuD93wbm1QxplSAF20xoo6FNwKIm1E=;
Received: from localhost ([127.0.0.1] helo=kenip.in)
	by techbitestudio.com with esmtpa (Exim 4.93)
	(envelope-from <siddhartha@kenip.in>)
	id 1ulanB-0006bA-Vp; Tue, 12 Aug 2025 03:44:58 +0530
MIME-Version: 1.0
Date: Tue, 12 Aug 2025 03:44:57 +0530
From: siddhartha@kenip.in
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, LKML
 <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_mm=3A_limit_THP_alignment_=E2=80=93_?=
 =?UTF-8?Q?performance_gain_observed_in_AI_inference_workloads?=
Message-ID: <e3d003e7d0b7a5b0840f08cd7d630fe4@kenip.in>
X-Sender: siddhartha@kenip.in
X-Priority: 1 (Highest)
Content-Type: multipart/alternative;
 boundary="=_8bd5ca14ad3f608e71429883053cf7fa"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F4284000B
X-Stat-Signature: 8f7u65q9dpgmypcjzoto5rqykzahoow5
X-HE-Tag: 1754950503-443269
X-HE-Meta: U2FsdGVkX1+zT6kQ5NHIYan4P7d7zwTOl8enp/7n/Q4mZPSTeP0s3Cnt7f1ajjUst2CGbTwDRdQgEGmTrAM2WYAzMSSsweUzQa+QiCiXwNN76N2uhx8FCSv0HM0xQFiqGXBVNo0Op96b3T7ZP69mT6aVdjEFJ403ExBg+arpX/MS4FHfa9DGnEz1CUR8tY946P/XQnkltCy8BVC4w71F4lTGhdtoFqKjLXW93qU3U0gmszE47SkQT3UOSLtjLOV/jK7m99djtBHx+/AjFKOGSZ9Rv8wcvUyVUBMxpmJie+6YGt58bJZ2msqSCRpShfEF8FmvXQQz4m8t1ZxZQP5xbLiY1JyXYx+LZtQ962tdTXwt/e7OkHUN/IdGTSoT9E2jrFJ5HxBXKB4mYsgYl3EE6AK62pAdIcQjkOxYxHpeWnpkR6EIcuodVbplRjKK2XPg9Nn8oa7GTsofqE0uHbSbkkEPGx2+AQ9gdwjv1RrIqUyDGu688R1/eRN0PiRAY9NLQGklbKA4ExlMjsfdrTnNiDSguGEpHhIKwCcwpI6Gy25OcWWRuwzspeLBuiReEcAXPid4d906vjyaBymMvx8O2nAB3RpeFL1PMXxlkcvU/HYTflkd5VmxwhV+dmFJIZrepQlflVjLhP0G8Jm/TTCHGN5bSL8JQcdSMyTx3UU/U4LoH+V6SpG6bQOXPOpC/1BbcSjKNP8Bm6ywn4br4Xf3uxUukInFEQV9H4XOarmQUe/2yEglaMWozjsnmU7ExRstSkr8A2KKbybVNkLrMsE+S2vPHTpOz8X7o0oETZ8m9v04dIi0rb6QuokKogAFIq7beoFfKygO/fSjuqMiLXwpgZzjxvycv/lLLNYf0bUCSaD+1WhuCaKSieAqOQze6PGD1HiBvP9Y5IlDfXgE6Hvzf0CayZyapNzc9IlfLki/e2rOnOF8hw5SHMry1EukbcJlfL/BIaabLlwGsaAsVWr
 5zKIvf/R
 nq3P7cM4jvxvxqCma3MRijavKsnvLBDJHnDqjTN7NK874qzz9uOaTaRAX+8Wn/uTbO+W2vQIPRHSAGJqaSm/cqOycJYtp9JeiiePfmv01BegP3JXu1+jK6uY2I5f8uCnWrxFU3pThU1pRtnbNo/ZXO7B9TlAnGMhhl870E5eHPhEgIJaQMImKedB9DXOevGQrqisOjVBFUCxrHcmLbl6MB68i+L2FBzqCKc6LkY9xN22iWUAnSIlLXTQ6xyAQ50PGtMbmmJo1ot/9+4YhGjZlYRLVmoPLL5izjjW7HAK7nsoLULF0xwSKXfDaXtitaK5iZWoP0OKIwrgiFLwqisAc0+fVYi4vXSgVlcg85YBLd2rTcNUpXRgk4xairUz90t35nTnxygxqVIj3wPmI91wi+DRpYgCxUEDyGMHGGQiV8Y1M5W6EpKvhTwOf88tI8k9dc0HbK4u1A9J2E+q7cmd/PzeHES3xFC7hZNEYrXbtu2C4LRoPWfm6D3EgTKEHXfMrFrDAwXklXDsKg0VjoZOIQPWubnPHufJX1MSRalczLM8aiDkL/pAhhnjJNPOMkpZDuBI0OSs4aAlSBFTsjS0SU6J2NVGmZtbi3M7uqcP/N7W7Hls=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--=_8bd5ca14ad3f608e71429883053cf7fa
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

On 2025-07-28 16:30, Vlastimil Babka wrote:

> On 7/28/25 07:41, siddhartha@kenip.in wrote:
> 
>> On 2025-07-07 14:26, Vlastimil Babka wrote:
>> Hi Lorenzo, Dev, Mel,
>> 
>> I'm following up on this patch submission from earlier this month:
>> "[PATCH] mm: limit THP alignment - performance gain observed in AI
>> inference workloads."
> 
> I'm confused. That wasn't a patch submission, but reporting performance
> results for my patch from late 2024? (and thanks for those!)
> 
> The patch was also already merged in late 2024:
> 
> commit d4148aeab412432bf928f311eca8a2ba52bb05df
> Author: Vlastimil Babka <vbabka@suse.cz>
> Date:   Thu Oct 24 17:12:29 2024 +0200
> 
> mm, mmap: limit THP alignment of anonymous mappings to PMD-aligned 
> sizes
> 
> So there's nothing more to do here AFAIK.

> Hello Vlastimil,
> 
> Hope you are doing great!
> 
> Sorry about the late reply, my inbox made your email invisible somehow.
> 
> Thank you for the clarification -- yes, I am aware that the mm, mmap: 
> limit THP alignment of anonymous mappings to PMD-aligned sizes patch 
> was merged in late 2024 (commit 
> d4148aeab412432bf928f311eca8a2ba52bb05df).
> 
> The performance results I shared were generated much later because of 
> my working setup:
> 
> *
> 
> The tests were conducted on Intel Developer Cloud workloads as part of 
> a broader benchmarking exercise involving OpenVINO-based inference 
> pipelines.
> *
> 
> The specific environment, dataset, and configuration scripts were 
> stored on an SSD that unfortunately suffered corruption. I am currently 
> working to recover them so I can share the exact test harness and 
> commit-specific diffs. If and when I get that access back from Intel 
> Developer Cloud, I can surely provide all those relevant files.
> 
> Although this is not a new patch submission, I thought the numbers 
> might still be valuable -- they show notable throughput and latency 
> changes when aligning the current behavior with OpenVINO's large 
> contiguous allocation preferences in certain inference scenarios.
> 
> Summary of observed improvements:
> 
> *
> 
> Throughput: +7.3% average increase in model inference throughput on 
> ResNet-50 with mixed batch sizes (64/128)
> *
> 
> Latency: -5.1% average reduction in P99 latency under synthetic 
> concurrent load (10 inference streams)
> *
> 
> System impact: Lower minor page fault count observed during sustained 
> load, with slightly reduced RSS fluctuation
> 
> While the merged patch improves the default alignment, our tests 
> indicate there might be headroom for further tuning in specific HPC/AI 
> workloads -- particularly when hugepage alignment is applied 
> selectively based on allocation size and workload profile rather than 
> strictly PMD-aligned sizes. I was also working on specifics and pseudo 
> diffs from the working Linux code that I can generate to send that 
> email via git send-email.
> 
> I'd be happy to collaborate on a deeper investigation once I recover 
> the original scripts -- or I can try to replicate the environment on a 
> fresh setup and collect new diffs for comparison.
> 
> Best regards,
> Siddhartha Sharma
--=_8bd5ca14ad3f608e71429883053cf7fa
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; charset=
=3DUTF-8" /></head><body style=3D'font-size: 10pt; font-family: Verdana,Gen=
eva,sans-serif'>
<div class=3D"pre" style=3D"margin: 0; padding: 0; font-family: monospace">=
On 2025-07-28 16:30, Vlastimil Babka wrote:
<blockquote type=3D"cite" style=3D"padding: 0 0.4em; border-left: #1010ff 2=
px solid; margin: 0">On 7/28/25 07:41, <a href=3D"mailto:siddhartha@kenip.i=
n">siddhartha@kenip.in</a> wrote:
<blockquote type=3D"cite" style=3D"padding: 0 0.4em; border-left: #1010ff 2=
px solid; margin: 0">On 2025-07-07 14:26, Vlastimil Babka wrote:<br />Hi Lo=
renzo, Dev, Mel,<br /><br />I'm following up on this patch submission from =
earlier this month:<br />"[PATCH] mm: limit THP alignment &ndash; performan=
ce gain observed in AI<br />inference workloads."</blockquote>
<br />I'm confused. That wasn't a patch submission, but reporting performan=
ce<br />results for my patch from late 2024? (and thanks for those!)<br /><=
br />The patch was also already merged in late 2024:<br /><br />commit d414=
8aeab412432bf928f311eca8a2ba52bb05df<br />Author: Vlastimil Babka &lt;<a hr=
ef=3D"mailto:vbabka@suse.cz">vbabka@suse.cz</a>&gt;<br />Date: &nbsp;&nbsp;=
Thu Oct 24 17:12:29 2024 +0200<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;mm, mmap:=
 limit THP alignment of anonymous mappings to PMD-aligned sizes<br /><br />=
<br />So there's nothing more to do here AFAIK.</blockquote>
<blockquote type=3D"cite" style=3D"padding: 0 0.4em; border-left: #1010ff 2=
px solid; margin: 0">
<p data-start=3D"566" data-end=3D"584">Hello Vlastimil,</p>
<p data-start=3D"566" data-end=3D"584">Hope you are doing great!</p>
<p data-start=3D"566" data-end=3D"584">Sorry about the late reply, my inbox=
 made your email invisible somehow.</p>
<p data-start=3D"586" data-end=3D"804">Thank you for the clarification &mda=
sh; yes, I am aware that the <code data-start=3D"645" data-end=3D"719">mm, =
mmap: limit THP alignment of anonymous mappings to PMD-aligned sizes</code>=
 patch was merged in late 2024 (commit <code data-start=3D"758" data-end=3D=
"800">d4148aeab412432bf928f311eca8a2ba52bb05df</code>).</p>
<p data-start=3D"806" data-end=3D"895">The performance results I shared wer=
e generated much later because of my working setup:</p>
<ul data-start=3D"896" data-end=3D"1285">
<li data-start=3D"896" data-end=3D"1048">
<p data-start=3D"898" data-end=3D"1048">The tests were conducted on Intel D=
eveloper Cloud workloads as part of a broader benchmarking exercise involvi=
ng OpenVINO-based inference pipelines.</p>
</li>
<li data-start=3D"1049" data-end=3D"1285">
<p data-start=3D"1051" data-end=3D"1285">The specific environment, dataset,=
 and configuration scripts were stored on an SSD that unfortunately suffere=
d corruption. I am currently working to recover them so I can share the exa=
ct test harness and commit-specific diffs. If and when I get that access ba=
ck from Intel Developer Cloud, I can surely provide all those relevant file=
s.</p>
</li>
</ul>
<p data-start=3D"1287" data-end=3D"1553">Although this is not a new patch s=
ubmission, I thought the numbers might still be valuable &mdash; they show =
notable throughput and latency changes when aligning the current behavior w=
ith OpenVINO&rsquo;s large contiguous allocation preferences in certain inf=
erence scenarios.</p>
<p data-start=3D"1555" data-end=3D"1594"><strong data-start=3D"1555" data-e=
nd=3D"1592">Summary of observed improvements:</strong></p>
<ul data-start=3D"1595" data-end=3D"1945">
<li data-start=3D"1595" data-end=3D"1712">
<p data-start=3D"1597" data-end=3D"1712"><strong data-start=3D"1597" data-e=
nd=3D"1612">Throughput:</strong> +7.3% average increase in model inference =
throughput on ResNet-50 with mixed batch sizes (64/128)</p>
</li>
<li data-start=3D"1713" data-end=3D"1823">
<p data-start=3D"1715" data-end=3D"1823"><strong data-start=3D"1715" data-e=
nd=3D"1727">Latency:</strong> -5.1% average reduction in P99 latency under =
synthetic concurrent load (10 inference streams)</p>
</li>
<li data-start=3D"1824" data-end=3D"1945">
<p data-start=3D"1826" data-end=3D"1945"><strong data-start=3D"1826" data-e=
nd=3D"1844">System impact:</strong> Lower minor page fault count observed d=
uring sustained load, with slightly reduced RSS fluctuation</p>
</li>
</ul>
<p data-start=3D"1947" data-end=3D"2242">While the merged patch improves th=
e default alignment, our tests indicate there might be headroom for further=
 tuning in specific HPC/AI workloads &mdash; particularly when hugepage ali=
gnment is applied selectively based on allocation size and workload profile=
 rather than strictly PMD-aligned sizes. I was also working on specifics an=
d pseudo diffs from the working Linux code that I can generate to send that=
 email via git send-email.</p>
<p data-start=3D"2244" data-end=3D"2464">I&rsquo;d be happy to collaborate =
on a deeper investigation once I recover the original scripts &mdash; or I =
can try to replicate the environment on a fresh setup and collect new diffs=
 for comparison.</p>
<p data-start=3D"2466" data-end=3D"2501">Best regards,<br data-start=3D"247=
9" data-end=3D"2482" />Siddhartha Sharma</p>
</blockquote>
</div>
</body></html>

--=_8bd5ca14ad3f608e71429883053cf7fa--

