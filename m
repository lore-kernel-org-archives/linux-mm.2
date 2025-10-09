Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD43CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 17:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43CA48E00A2; Thu,  9 Oct 2025 13:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 414398E002C; Thu,  9 Oct 2025 13:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351888E00A2; Thu,  9 Oct 2025 13:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22F768E002C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:30:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9D7C8843A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:30:38 +0000 (UTC)
X-FDA: 83979265356.01.17980F1
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE7D010000E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:30:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K7obZ9Xg;
	spf=pass (imf14.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760031037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNVeIx8TUnw5Ay8gWM76swrUncD7ZxnqoC2Eii7HoKE=;
	b=MQVTap4KkVBCVnzdbSShZ4DWUFx5GU0+WwL3vjf2lreE7NiEKfR1fVyU7kHx1zxgLGB2e5
	NWk21SgyymPGy7yQ2lflTDY+98ffifzoQHckVKeaX8A/OdqPOOO5lrzUgw3SQWvcepOyoH
	ua+G7f0FJ3fCT5IVuNd6dGECw1e4na4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K7obZ9Xg;
	spf=pass (imf14.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760031037; a=rsa-sha256;
	cv=none;
	b=KuPB7s7mqiVhF/ieJp3PioTDkTJ6Tynrm83C4vSADwFBXJFGQyRvi36pFOnmEjmLH/xoUa
	NBC/gFI3rqv0Cno3kahhtCc79oxnRjgqEDFEOdr47CWjG6njdgGPAayeYXyBebu9fuojxh
	+nrTyX2jdRWl7BIpoQbYhL3XaPbT0DQ=
Content-Type: multipart/alternative;
 boundary="------------53YpYP3nVmGuecZPt5zIByBG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760031033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eNVeIx8TUnw5Ay8gWM76swrUncD7ZxnqoC2Eii7HoKE=;
	b=K7obZ9XgRykvRJS3680oeEV+FrDL2fkBCC75t3YrKNhR/1GdgUNauOlrxVD8se5sdKLAq0
	q5lFNwnz6Q18mVoVXUbLRq881Z7oaaMRtDI7m83rhLlJ2qsJXNz85eluGnDXYWgErxaeBZ
	VTV45mqCTPQh3fvvgJZ9l9RUHOSkLwg=
Message-ID: <c2b29aab-6a3b-4d82-8d7d-feebda1fc9a8@linux.dev>
Date: Thu, 9 Oct 2025 10:30:18 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state
 monitoring
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com,
 graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
 dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
 rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
 kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
 masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
 yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
 chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
 jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
 dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org,
 rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org,
 zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org,
 cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com,
 Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
 aleksander.lobakin@intel.com, ira.weiny@intel.com,
 andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
 bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
 stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
 ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
 leonro@nvidia.com, witu@nvidia.com
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-20-pasha.tatashin@soleen.com>
 <a27f9f8f-dc03-441b-8aa7-7daeff6c82ae@linux.dev>
 <mafs0qzvcmje2.fsf@kernel.org>
 <CA+CK2bCx=kTVORq9dRE2h3Z4QQ-ggxanY2tDPRy13_ARhc+TqA@mail.gmail.com>
 <dc71808c-c6a4-434a-aee9-b97601814c92@linux.dev>
 <CA+CK2bBz3NvDmwUjCPiyTPH9yL6YpZ+vX=o2TkC2C7aViXO-pQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <CA+CK2bBz3NvDmwUjCPiyTPH9yL6YpZ+vX=o2TkC2C7aViXO-pQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dcbm86drbumtzwsfwxzsc4u5hwhtojdx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AE7D010000E
X-HE-Tag: 1760031036-726733
X-HE-Meta: U2FsdGVkX1+TXGlwwy+KeRZXLWfNBR4BxYW9d532NXqWKvCY+qJ1HJZbVpH9SnFcnf6XU8JvFn24R3TDZoH8I06rHXHvUt2KnjDf7/5x+Yl6ayINyiaRXmcn5/Vo6zIGJDiRR3H3LGd326BE14nwWQQOm7ubqakqmVuI0qGtET+wqoySVF52p4Zi+eTFgr0c7efKxZu+ewGbQANd9N3XTfX6KyT1Nyx4XG92HlQUmpRR39nSJcHLDBI0WQBCp6wID13o25TnAqD/TPogChtKYMhVxdSGQvTmSARJlwxCvemaN+IRmSon/N3CPu8FSVBA9dgx1ieE/fDcgnXllgu8VgP/Dylvl9wO6xx3Mi+Dsb8xZT0eCBVL/QG5bUZc6dVjYewNufDSFGgm7DDgQ+uXc6hWobevGxTq7ft2bruWCs3viAbgjydPdwz3lqpVWgCCdaQPVaXw5BZVm3TSPw2VGXmd2Cf4B5G9SNm96MqHQi+3zQ8JORIvcpIJ8vl+lVlg3ZJUOE4Fn3It9B22kNX9XrofGlhTMHfDpMdvfha1Nl7Un9d+fidt7Z3fmbnjBhnq/S4UmsHFa2uX4ZkpRpPkBWfCSvcvEaSroXSaiUQDr+RUPpcYW+lpYh4KECUGmBwCM9KQfcoz/9jmN8R5tCrTer0iNGOt4/n9Bfu3U2hiQ109EZo7JOu8NWtrDRzT32vINkrAgHTzTpoNPS7B/wHloSCnP2W96XzisXeL77INnrjW5Fqvw5/y0FMJpD4DpiVXI6kAkpDf0vIQqUDcZ70jt0lS1EofMHHqHlgEXIg3AxvQbZP4auyr9mvUJ2rZoyZ6W1dbGl08dNFH+jr/3NA8pi53g6tkDK1L8XIFNEmVqjcGMPJmynVBoCXPAoDWy14kk3yNg3iPUU7TnhD5FV31xKfqlztGu9zNucj2okMdEkX8VoTpd6zwuL0TA0Evvfl4mtCd0BnPazN9OXhS/OZ
 C/AWzZ6Q
 om9bk5F4p4cQWsXZ+f541I6cpPB56HvecED3WdqjlANoTjcueqgg899j/Q7NtvgU3DfdsyYBtiWES3YIzRSFioU5Kx0pqvFKWXlGAtyCBieMIyspMdZ8jw/HtHbn/w2aZVbrTDlk5r5tGpv3Yy/zXUyeECgjJNzVPhFcSLkfN5gNXQEn6J+dMmG/PCCdmCbSmsoHQHgxZVqlFUTWhWNQqZ9DB+8vhPUFByXbXLanSq9GvIlfGqoHX7lcZhCGazX9vuChZERH87LbiBYLvS1FgHm6se8ePcpFpBr2f30Sqq+sYLe5jAp7yao1yj3eWNW5ih4NtouonisJ6cgQnksleh4BI5ZTIBz49E0MMAZbVPwy//UAgZaulzbuMVZhuht4iuPDSg8C+ULP4WjDdw2EgbsB5LKgfb9+OCBeG1Bh7omi/FnsVZszsIYeVWsuNI13fcCmBSpwZbNJqOxyumfVyTz5DcIrIC11XEpkjq5vuxzxDdQKpaVGslQptmyl8IIHyLBT8GCvDvPkH6SjfWCZ3AyJG0g/2IBaA2Ocw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------53YpYP3nVmGuecZPt5zIByBG
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 10/9/25 10:04 AM, Pasha Tatashin wrote:
> On Thu, Oct 9, 2025 at 11:35 AM Zhu Yanjun<yanjun.zhu@linux.dev> wrote:
>>
>> 在 2025/10/9 5:01, Pasha Tatashin 写道:
>>>>> Because the window of kernel live update is short, it is difficult to statistics
>>>>> how many times the kernel is live updated.
>>>>>
>>>>> Is it possible to add a variable to statistics the times that the kernel is live
>>>>> updated?
>>>> The kernel doesn't do the live update on its own. The process is driven
>>>> and sequenced by userspace. So if you want to keep statistics, you
>>>> should do it from your userspace (luod maybe?). I don't see any need for
>>>> this in the kernel.
>>>>
>>> One use case I can think of is including information in kdump or the
>>> backtrace warning/panic messages about how many times this machine has
>>> been live-updated. In the past, I've seen bugs (related to memory
>>> corruption) that occurred only after several kexecs, not on the first
>>> one. With live updates, especially while the code is being stabilized,
>>> I imagine we might have a similar situation. For that reason, it could
>>> be useful to have a count in the dmesg logs showing how many times
>>> this machine has been live-updated. While this information is also
>>> available in userspace, it would be simpler for kernel developers
>>> triaging these issues if everything were in one place.
>> I’m considering this issue from a system security perspective. After the
>> kernel is automatically updated, user-space applications are usually
>> unaware of the change. In one possible scenario, an attacker could
>> replace the kernel with a compromised version, while user-space
>> applications remain unaware of it — which poses a potential security risk.
>>
>> To mitigate this, it would be useful to expose the number of kernel
>> updates through a sysfs interface, so that we can detect whether the
>> kernel has been updated and then collect information about the new
>> kernel to check for possible security issues.
>>
>> Of course, there are other ways to detect kernel updates — for example,
>> by using ftrace to monitor functions involved in live kernel updates —
>> but such approaches tend to have a higher performance overhead. In
>> contrast, adding a simple update counter to track live kernel updates
>> would provide similar monitoring capability with minimal overhead.
> Would a print during boot, i.e. when we print that this kernel is live
> updating, we could include the number, work for you? Otherwise, we
> could export this number in a debugfs.

IMO, it would be better to export this number via *debugfs*. This 
approach reduces the overhead involved in detecting a kernel live update.

If the number is printed in logs instead, the overhead would be higher 
compared to using debugfs.

Thanks a lot.

Yanjun.Zhu

>
> Pasha
--------------53YpYP3nVmGuecZPt5zIByBG
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
    <div class="moz-cite-prefix">On 10/9/25 10:04 AM, Pasha Tatashin
      wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:CA+CK2bBz3NvDmwUjCPiyTPH9yL6YpZ+vX=o2TkC2C7aViXO-pQ@mail.gmail.com">
      <pre wrap="" class="moz-quote-pre">On Thu, Oct 9, 2025 at 11:35 AM Zhu Yanjun <a class="moz-txt-link-rfc2396E" href="mailto:yanjun.zhu@linux.dev">&lt;yanjun.zhu@linux.dev&gt;</a> wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">

在 2025/10/9 5:01, Pasha Tatashin 写道:
</pre>
        <blockquote type="cite">
          <blockquote type="cite">
            <blockquote type="cite">
              <pre wrap="" class="moz-quote-pre">Because the window of kernel live update is short, it is difficult to statistics
how many times the kernel is live updated.

Is it possible to add a variable to statistics the times that the kernel is live
updated?
</pre>
            </blockquote>
            <pre wrap="" class="moz-quote-pre">The kernel doesn't do the live update on its own. The process is driven
and sequenced by userspace. So if you want to keep statistics, you
should do it from your userspace (luod maybe?). I don't see any need for
this in the kernel.

</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">One use case I can think of is including information in kdump or the
backtrace warning/panic messages about how many times this machine has
been live-updated. In the past, I've seen bugs (related to memory
corruption) that occurred only after several kexecs, not on the first
one. With live updates, especially while the code is being stabilized,
I imagine we might have a similar situation. For that reason, it could
be useful to have a count in the dmesg logs showing how many times
this machine has been live-updated. While this information is also
available in userspace, it would be simpler for kernel developers
triaging these issues if everything were in one place.
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">I’m considering this issue from a system security perspective. After the
kernel is automatically updated, user-space applications are usually
unaware of the change. In one possible scenario, an attacker could
replace the kernel with a compromised version, while user-space
applications remain unaware of it — which poses a potential security risk.

To mitigate this, it would be useful to expose the number of kernel
updates through a sysfs interface, so that we can detect whether the
kernel has been updated and then collect information about the new
kernel to check for possible security issues.

Of course, there are other ways to detect kernel updates — for example,
by using ftrace to monitor functions involved in live kernel updates —
but such approaches tend to have a higher performance overhead. In
contrast, adding a simple update counter to track live kernel updates
would provide similar monitoring capability with minimal overhead.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Would a print during boot, i.e. when we print that this kernel is live
updating, we could include the number, work for you? Otherwise, we
could export this number in a debugfs.</pre>
    </blockquote>
    <p data-start="67" data-end="210">IMO, it would be better to export
      this number via <strong data-start="117" data-end="128">debugfs</strong>.
      This approach reduces the overhead involved in detecting a kernel
      live update.</p>
    <p data-start="217" data-end="314">If the number is printed in logs
      instead, the overhead would be higher compared to using debugfs.</p>
    <p>Thanks a lot.</p>
    <p>Yanjun.Zhu</p>
    <blockquote type="cite"
cite="mid:CA+CK2bBz3NvDmwUjCPiyTPH9yL6YpZ+vX=o2TkC2C7aViXO-pQ@mail.gmail.com">
      <pre wrap="" class="moz-quote-pre">

Pasha
</pre>
    </blockquote>
  </body>
</html>

--------------53YpYP3nVmGuecZPt5zIByBG--

