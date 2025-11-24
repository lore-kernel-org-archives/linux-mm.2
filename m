Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA10CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 11:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD696B0026; Mon, 24 Nov 2025 06:47:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66DAC6B0029; Mon, 24 Nov 2025 06:47:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C406B002C; Mon, 24 Nov 2025 06:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB616B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:47:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E121388250
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:47:08 +0000 (UTC)
X-FDA: 84145324536.22.E67CC86
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id B0BB440005
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:47:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763984827; a=rsa-sha256;
	cv=none;
	b=4TRSiVT1oQIU6nJKfl+WeX1HKPAbqz6lL2ukNahPQC8vU8O5u4RKiMfWpvaCimZxpP/jSR
	I/JZcg1DQPxK5OEHPwtKi9AAFepXFZ8SDwkbkmVTmVqO8er+GaWbcCoz1ot2kOctCj/qt6
	6s7oTcsmNRAFDew4wreYkPRd3zG1zfM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763984827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SgefOsFQ8wvgDR8vXzvR99q4T/uL7fdev/6bLSa9Vi0=;
	b=7NowJQSxPepXWP/3bHjFTAFyySYTS7hGBdZhjYYw2JDybPZBj9pZXfDLx+3Exe2q2iIcP2
	izKt7fDdcRTzsLAMk12ewssVLbsgJZ71z1ZZ6MJsz7XofInpCui7QZo2obo1h0OYtSUWeZ
	2kRd7MThNOaZOn8Kx31V7Zcr/AVgg18=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB155497;
	Mon, 24 Nov 2025 03:46:57 -0800 (PST)
Received: from [10.164.136.37] (unknown [10.164.136.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2CB003F73B;
	Mon, 24 Nov 2025 03:46:59 -0800 (PST)
Content-Type: multipart/alternative;
 boundary="------------thNrygBUgWfgiX81FPhfmB7K"
Message-ID: <9d4774ec-41d4-4c6f-899a-991187e58897@arm.com>
Date: Mon, 24 Nov 2025 17:16:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: khugepaged: fix memory leak in collapse_file rollback
 path
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Shardul Bankar <shardul.b@mpiricsoftware.com>, shardulsb08@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzbot+a785d07959bc94837d51@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 janak@mpiricsoftware.com
References: <20251123132727.3262731-1-shardul.b@mpiricsoftware.com>
 <36896775-5083-4b3e-9023-949de7722194@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <36896775-5083-4b3e-9023-949de7722194@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B0BB440005
X-Stat-Signature: zm4oqr5jpsg9fm5j1se3cfubhozo8ppm
X-Rspam-User: 
X-HE-Tag: 1763984826-529642
X-HE-Meta: U2FsdGVkX1+8Ctk0qNRn+zFEgRWSOiXRMRhshrFLUxoQ1qahX8xaO11fswvdHyN5JV3Q2+tW+r05y5GerhO8FIkcQPw9v+vCAtzx4EVpFJHNGzmNvX4gVuiZ4ZTyFdkoJgKq8F0ugKjjKdI79jMT7ArmgLXaV9JM0GOnIqmcFAqQ7bPx0yW5SqtfhGRYSf7kEjE8gxipudQcR4aHNvGk/YluSOVrC0X/jb5UBRx6wYNiHcChjIFkkHtPDsq474iSHA/VjApAHK6GBVgDys9gzYpoF8eK9ttxdo9jJnJh5fEHzDp1Mrtahq1vIfrw0ALY5Y2kSSi3rl5aM7uHHeXEZYoEi6ygLTuW+Q4HUyB9PHb3xrYcUVyqQj1rZBvFOEsfbLhJeeXizGI2QI0hytdYMR2/X9E5/uNZkQEkcUDAXCm+b28cbnB1pD5OPTTkaTTz+5cN5mOIlFRx20k1x2cVnl8ATGFToAA34sImBYkGLY6qS0tPwFZenx32WWeVcshUd3FHg0f3m4G1SD3+Un9+AF8Jj8LBpt9D/aESPSfOr+GN4HzFx6OhZb7YoivFNAABPN90BoEIFd5fHDs5SCdWTF6AzsyAP9nvwkV0+UF7CNY0GBjl1+OE8b94K++XVXTPTUJMzNXA7p98Wv1bcJMtllTHhTm0Dd3x3LwdEomFqcmoyyN1RDEG2CCYO7CKkDGPutfFkbjQyrsXWDjSjJpzwKmq/GZ4sr7hymFVEuK4x+Q9GYSSL5eFrvWj1BG6jeIK4QzdzqDHBwxztKlnMXVGhEtk3XGCHD33lgJdGsPSOVnMRinpjmhVB0QKvMJLtlzKpax+fKL6Y6y6LHDl9jesiJS52EgzYKXhja+yNBk+iF7uN3q2taW7sXSJnGZ6bOdzRoprgkIyZEK20aqC6itsstFGy7WyWKV3k0M8HrK1VrmALjT29YsxS5+ibQGg1GqGVCGIEJkubMx08OCX8/i
 WCXFQXzr
 dGXhwcgEoPUtX89DtDwhbbYPVpdeUrSo52cljmhiIN1Dx9JyD6dx4L2FLUhpuar+Koh1gQhuKEx0h7C26eqNE6QLcUtweuxTvV3R8pw2BttH5oNabuLzLArKLwas6DWKXSMoZXpDDIEyT3mu4DDKEEau+XbCTSkSOp26tIfq8QHx0TKtQEKt4SgUKR3Jq1Oc+crbxjjFPqpCa7wZY9brgkhAV/6N7c7buVt09UN0vhWDThcqn7Z/HJjbO3u1dImEcYjKXa3unvZ6ULYjeFdQ1KiG8twgJkT9LTYeyhQCp5Ddce1BmPGYLQpP2sqOZsWVmhhE1bQFPV8dyAcIDukL/CUDSDwBIS9LRZy60OiucTHujhfBDne2DkmpVquJW6USz0ta6ia4BKedygRHhcNKfYKkMgvvy+nJG5xIPs7HyGg3VjlPPWxr++nj5duAM/vCAgg4XhtfkDQXkgerouRwUZQy7l1t9q8O6Hr+U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------thNrygBUgWfgiX81FPhfmB7K
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 24/11/25 3:32 pm, David Hildenbrand (Red Hat) wrote:
> On 11/23/25 14:27, Shardul Bankar wrote:
>> When collapse_file() fails after xas_create_range() succeeds, the
>> rollback path does not clean up pre-allocated XArray nodes stored in
>> xas->xa_alloc. These nodes are allocated by xas_nomem() when
>> xas_create() fails with GFP_NOWAIT and need to be freed.
>>
>> The leak occurs because:
>> 1. xas_create_range() may call xas_nomem() which allocates a node
>>     and stores it in xas->xa_alloc
>
> Do you mean that, if xas_create_range() failed, collapse_file() will 
> call xas_nomem() to preallocate memory?
>
> I don't immediately see how xas_create_range() would call xas_nomem().
>
>> 2. If the collapse operation fails later, the rollback path jumps
>>     to the 'rollback:' label
>> 3. The rollback path cleans up folios but does not call xas_destroy()
>>     to free the pre-allocated nodes in xas->xa_alloc
>
> Note that after we call xas_nomem(), we retry xas_create_range() -- 
> that previously failed to to -ENOMEM.
>
> So the assumption is that the xas_create_range() call would consume 
> that memory.
>
> I'm sure there is some corner case where it is not the case (some 
> concurrent action? not sure)

Someone else can put slots in the xarray since we dropped the lock. I 
cannot prove this, but surely

disproving this is harder : )


>
>>
>> Fix this by calling xas_destroy(&xas) at the beginning of the rollback
>> path to free any pre-allocated nodes. This is safe because xas_destroy()
>> only frees nodes in xas->xa_alloc that were never inserted into the
>> XArray tree.
>
> Shouldn't we just call xas_destroy() in any case, also when everything 
> succeeded?

Yeah you are right. We should probably do

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0043c7..0794a99c807f100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1872,11+1872,14@@ staticintcollapse_file(structmm_struct *mm, 
unsignedlongaddr,
do{
xas_lock_irq(&xas);
xas_create_range(&xas);
- if(!xas_error(&xas))
+ if(!xas_error(&xas)) {
+ xas_destroy(&xas);
break;
+ }
xas_unlock_irq(&xas);
if(!xas_nomem(&xas, GFP_KERNEL)) {
result = SCAN_FAIL;
+ xas_destroy(&xas);
gotorollback;
}
} while(1);


--------------thNrygBUgWfgiX81FPhfmB7K
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 24/11/25 3:32 pm, David Hildenbrand
      (Red Hat) wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:36896775-5083-4b3e-9023-949de7722194@kernel.org">On
      11/23/25 14:27, Shardul Bankar wrote:
      <br>
      <blockquote type="cite">When collapse_file() fails after
        xas_create_range() succeeds, the
        <br>
        rollback path does not clean up pre-allocated XArray nodes
        stored in
        <br>
        xas-&gt;xa_alloc. These nodes are allocated by xas_nomem() when
        <br>
        xas_create() fails with GFP_NOWAIT and need to be freed.
        <br>
        <br>
        The leak occurs because:
        <br>
        1. xas_create_range() may call xas_nomem() which allocates a
        node
        <br>
            and stores it in xas-&gt;xa_alloc
        <br>
      </blockquote>
      <br>
      Do you mean that, if xas_create_range() failed, collapse_file()
      will call xas_nomem() to preallocate memory?
      <br>
      <br>
      I don't immediately see how xas_create_range() would call
      xas_nomem().
      <br>
      <br>
      <blockquote type="cite">2. If the collapse operation fails later,
        the rollback path jumps
        <br>
            to the 'rollback:' label
        <br>
        3. The rollback path cleans up folios but does not call
        xas_destroy()
        <br>
            to free the pre-allocated nodes in xas-&gt;xa_alloc
        <br>
      </blockquote>
      <br>
      Note that after we call xas_nomem(), we retry xas_create_range()
      -- that previously failed to to -ENOMEM.
      <br>
      <br>
      So the assumption is that the xas_create_range() call would
      consume that memory.
      <br>
      <br>
      I'm sure there is some corner case where it is not the case (some
      concurrent action? not sure) <br>
    </blockquote>
    <br>
    <p>Someone else can put slots in the xarray since we dropped the
      lock. I cannot prove this, but surely</p>
    <p>disproving this is harder : )</p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:36896775-5083-4b3e-9023-949de7722194@kernel.org"><br>
      <blockquote type="cite">
        <br>
        Fix this by calling xas_destroy(&amp;xas) at the beginning of
        the rollback
        <br>
        path to free any pre-allocated nodes. This is safe because
        xas_destroy()
        <br>
        only frees nodes in xas-&gt;xa_alloc that were never inserted
        into the
        <br>
        XArray tree.
        <br>
      </blockquote>
      <br>
      Shouldn't we just call xas_destroy() in any case, also when
      everything succeeded? <br>
    </blockquote>
    <br>
    <p>Yeah you are right. We should probably do</p>
    <div
style="color: #000000;background-color: #ffffff;font-family: Menlo, Monaco, 'Courier New', monospace;font-weight: normal;font-size: 12px;line-height: 18px;white-space: pre;"><div><span
    style="color: #000000;">diff --git a/mm/khugepaged.c b/mm/khugepaged.c</span></div><div><span
    style="color: #000000;">index abe54f0043c7.</span><span
    style="color: #cd3131;">.0794a99c807f</span><span
    style="color: #000000;"> </span><span style="color: #098658;">100644</span></div><div><span
    style="color: #000000;">--- a/mm/khugepaged.c</span></div><div><span
    style="color: #000000;">+++ b/mm/khugepaged.c</span></div><div><span
    style="color: #000000;">@@ -</span><span style="color: #098658;">1872</span><span
    style="color: #000000;">,</span><span style="color: #098658;">11</span><span
    style="color: #000000;"> +</span><span style="color: #098658;">1872</span><span
    style="color: #000000;">,</span><span style="color: #098658;">14</span><span
    style="color: #000000;"> @@ </span><span style="color: #0000ff;">static</span><span
    style="color: #000000;"> </span><span style="color: #0000ff;">int</span><span
    style="color: #000000;"> </span><span style="color: #795e26;">collapse_file</span><span
    style="color: #000000;">(</span><span style="color: #0000ff;">struct</span><span
    style="color: #000000;"> mm_struct *</span><span
    style="color: #001080;">mm</span><span style="color: #000000;">, </span><span
    style="color: #0000ff;">unsigned</span><span style="color: #000000;"> </span><span
    style="color: #0000ff;">long</span><span style="color: #000000;"> </span><span
    style="color: #001080;">addr</span><span style="color: #000000;">,</span></div><div><span
    style="color: #000000;">        </span><span style="color: #af00db;">do</span><span
    style="color: #000000;"> {</span></div><div><span
    style="color: #000000;">                </span><span
    style="color: #795e26;">xas_lock_irq</span><span
    style="color: #000000;">(&amp;xas);</span></div><div><span
    style="color: #000000;">                </span><span
    style="color: #795e26;">xas_create_range</span><span
    style="color: #000000;">(&amp;xas);</span></div><div><span
    style="color: #000000;">-               </span><span
    style="color: #af00db;">if</span><span style="color: #000000;"> (!</span><span
    style="color: #795e26;">xas_error</span><span
    style="color: #000000;">(&amp;xas))</span></div><div><span
    style="color: #000000;">+               </span><span
    style="color: #af00db;">if</span><span style="color: #000000;"> (!</span><span
    style="color: #795e26;">xas_error</span><span
    style="color: #000000;">(&amp;xas)) {</span></div><div><span
    style="color: #000000;">+                       </span><span
    style="color: #795e26;">xas_destroy</span><span
    style="color: #000000;">(&amp;xas);</span></div><div><span
    style="color: #000000;">                        </span><span
    style="color: #af00db;">break</span><span style="color: #000000;">;</span></div><div><span
    style="color: #000000;">+               }</span></div><div><span
    style="color: #000000;">                </span><span
    style="color: #795e26;">xas_unlock_irq</span><span
    style="color: #000000;">(&amp;xas);</span></div><div><span
    style="color: #000000;">                </span><span
    style="color: #af00db;">if</span><span style="color: #000000;"> (!</span><span
    style="color: #795e26;">xas_nomem</span><span
    style="color: #000000;">(&amp;xas, GFP_KERNEL)) {</span></div><div><span
    style="color: #000000;">                        result = SCAN_FAIL;</span></div><div><span
    style="color: #000000;">+                       </span><span
    style="color: #795e26;">xas_destroy</span><span
    style="color: #000000;">(&amp;xas);</span></div><div><span
    style="color: #000000;">                        </span><span
    style="color: #af00db;">goto</span><span style="color: #000000;"> rollback;</span></div><div><span
    style="color: #000000;">                }</span></div><div><span
    style="color: #000000;">        } </span><span
    style="color: #af00db;">while</span><span style="color: #000000;"> (</span><span
    style="color: #098658;">1</span><span style="color: #000000;">);</span></div>

</div>
    <p><br>
    </p>
  </body>
</html>

--------------thNrygBUgWfgiX81FPhfmB7K--

