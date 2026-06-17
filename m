Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B590CD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 22:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9DC6B008A; Wed, 17 Jun 2026 18:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA886B008C; Wed, 17 Jun 2026 18:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7036B0092; Wed, 17 Jun 2026 18:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6B96B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:31:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C23EA04A3
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:31:51 +0000 (UTC)
X-FDA: 84890853222.13.261BEDE
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3B89B180002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:31:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mzFDW0pr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781735509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=932P7j4+kVPkCsbzaJNwD/gpMUS7xJYuYYBSNyy6MMw=;
	b=XMdknP0aQuDeiET1+THiJncehp0rpnWGooCWhQiUEhrgpX3QHgm/DiTa8aHZLEos3MuVmx
	0vtGiCRC76mq96qDhe5t7bP6VYK53AwkIbfioRx6Jw0bQGTQiop0R4tr2P7LHIFFSQftJH
	25MG+8X17ndoGxZWg9h04pVQYweA0q8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mzFDW0pr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781735509;
	b=qqIMMGTEg66ErCGFdKYg1QQv7m073L9C1zaSMuRQdqMmFr/HF7wg7p962L3Hd56ctOjk57
	Q3mWsHIkeNJ8OCIQRNpNQCWpYMitjJpAc7vIoTbNFNvsi/kNAnNIQK8igLSFfWnhib2l0S
	KZ4L71V/SerRNOU9F39jWcwy9P5XN5k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781735506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=932P7j4+kVPkCsbzaJNwD/gpMUS7xJYuYYBSNyy6MMw=;
	b=mzFDW0prvbckaS+i1HZkAb+l0HQkoF84AwC74+AzNGZwtQNi2RdM1MK5p2ztt2WiqWt3uS
	OZsKMgl8fmU4jxcdWPCkNWGklacmBCa6Sny6t2EHuGoIV1bHAvCHF9qNack3nZzZ8RaXdk
	XoLHkokSK//4lElYheSKb8MYNF3DigU=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: JP Kobryn <jp.kobryn@linux.dev>,  Shakeel Butt <shakeel.butt@linux.dev>,
  Andrew Morton <akpm@linux-foundation.org>,  Alexei Starovoitov
 <ast@kernel.org>,  bpf <bpf@vger.kernel.org>,  linux-mm
 <linux-mm@kvack.org>,  LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/bpf_memcontrol: mark BPF memcg kfuncs static
In-Reply-To: <CAADnVQJ=q7hJkt=ekLD_a5KjJ_+icdwgsY61rujjLMKAKByvWw@mail.gmail.com>
	(Alexei Starovoitov's message of "Wed, 17 Jun 2026 14:06:31 -0700")
References: <20260617202147.78347-1-jp.kobryn@linux.dev>
	<CAADnVQJ=q7hJkt=ekLD_a5KjJ_+icdwgsY61rujjLMKAKByvWw@mail.gmail.com>
Date: Wed, 17 Jun 2026 22:31:38 +0000
Message-ID: <7ia4cxxosss5.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3B89B180002
X-Rspam-User: 
X-Stat-Signature: 8rhubyopmu8591dqk7bn5nktdk1hqz41
X-Rspamd-Server: rspam09
X-HE-Tag: 1781735509-746000
X-HE-Meta: U2FsdGVkX18SEQ6xzIXQLazpnSc0oUerSVRcInP6aQLCdSavg2JsOp6ogxYYhxwr2fEtGm9RMHj40+rUvT9CyFDNu57xs41UC+8+pGcSfW0tWB5WpKoeMgJN2Y6xC+tDAIeSHqzzk3Fs8d40NYpdK57Qp6JZC03vLjHiPi6msZX/pan+GixRO9pPVjNWNd3SuJ2vxSgsNdy9bp/4SiUOXUTDImeC+DPwy4IoG3cgsj5f3CCyr3QHMURYHbUHeJNxw4BP43ueIC+42lZeUzixNXE5oUXILy6qam/nCTLDZ7HEQdNXmsKMpwVevlOfwGNxCywN78A75ABT6LhvahEj0CTjd1vOOY6VlFyHcbi8gphFF19QTRobDh0pHCJFybrCcXRSS2BjBhjuQ/xLqO7boPM5FhpwdVGrhIp8dCVTlzpRvpABk0hsp0OT3Hcc8p8X59FDyVt3SvVbszdyW2mg24rCLLZdVtQ+p2wBMPGv42aVyYVWfAg+0WqDuV3R76dx7hACYCpajnCEiuWYYXP8wwRZw4D+0rc8NU6jlGxteNb1sKQJ+OMpnVgm8i4qGmVldj27bmMohFW8yGPpFEns082epQ+9VztVDx02F1tIK3vj9sWAYsrlmrAZ4B6C6taDGPV46n3sD0BXe1wuBiYp3FhEZy+nJpjMslCZ3McqGQm5oin/oM9lAe1jSaR4fbZj2plbMgzEieK8SyAXqrvRGyVXFQ/CJs/6dk3stKjhBTeS8aQzrmEc3ZQU8wxy2ktNorEjl5FKTmFb0uM3QYj4hUco1TmL63zxvuIRoskDcLcyGnPsEPeX8K69AtFyN6y/FAdkCJl1CoSksCPi9TC3Q+i32Dt0TnFL+uV0zU0bIYBAUnIsO5yeGP5Fm/PpLuTQiikLv257UBfrZLX+azpioI2FzHZppJnMAabs0AplmVa5cwKvJpdQ8hW75uO6c79+g5q7R0zUreRtcgpSU2A
 qzWDdmh5
 CXYv/lRER7Lqm5n8kJHOCkMSeCIvyyxyRDjz09ysG2Rr6o3fHdKah3XAfD7dXkTRvAM7SQLl1KkSOaUJk7qBkNvkrFsOFl3a6Tlq1z8TOaARRFoQ2IiQi78NU44QO+ePnVBZnQNd8SR0s4WwVV6I6XAGaJRFjpMIkoNgibmiepmnvVpRuNMzZhi4pNmLzVR6pLyfvI5ooNb+e7VmDAV2lkvgUZPpaGLaRMXngdE034t42bztWhwtmbr/pI9CxPnGi29TrwIKCfbwX1vGpwLI10OtNRAIG2ioNmsoMAuWZo9mupLKUJPx6vj70ReRP/dFT3+Xi5JvEtZw2dbTGSC8icW1KMui/lzolHrPVoxYYWIqRoGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Jun 17, 2026 at 1:22=E2=80=AFPM JP Kobryn <jp.kobryn@linux.dev> w=
rote:
>>
>> The kfuncs in bpf_memcontrol.c are not called by in-kernel C code. They =
are
>> only referenced by BPF programs and resolved through BTF.
>>
>> Since no external linkage is needed, mark these functions static.
>>
>> Fixes: 5904db9891f8 ("mm: introduce BPF kfuncs to deal with memcg pointe=
rs")
>> Fixes: 5c7db3239c9f ("mm: introduce bpf_get_root_mem_cgroup() BPF kfunc")
>> Fixes: 99430ab8b804 ("mm: introduce BPF kfuncs to access memcg statistic=
s and events")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202606150332.Xy4Egd9s-lkp@=
intel.com/
>> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
>> ---
>>  mm/bpf_memcontrol.c | 21 +++++++++++----------
>>  1 file changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index 716df49d7647..eff79bb2c758 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>> @@ -20,7 +20,7 @@ __bpf_kfunc_start_defs();
>>   *
>>   * Return: A pointer to the root memory cgroup.
>>   */
>> -__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
>> +__bpf_kfunc static struct mem_cgroup *bpf_get_root_mem_cgroup(void)
>
> sashiko disappoints. It couldn't notice that kfuncs should not be static.
> We have few "__bpf_kfunc static" in net/ipv4/
> that work by sort-of "luck", since their addresses are taken.
>
> In general kfuncs cannot be declared static.

It seems like it thought hard on it but failed based on the existing
code and a bit vague documentation in Documentation/bpf/kfuncs.rst:

  kfunc definitions should also always be annotated with the ``__bpf_kfunc``
  macro. This prevents issues such as the compiler inlining the kfunc if it=
's a
  static kernel function, or the function ...

So it reads like bpf kfuncs can be static.

This is the reasoning from the logs (a dismissed concern, to be precise):
{
      "type": "Dead Code / Linker Error",

      "description": "Marking kfuncs as static could cause the compiler
      to optimize them away, breaking BPF verifier BTF resolution.",

      "reasoning": "The patch adds `static` to multiple `__bpf_kfunc`
      annotated functions that are not called anywhere in C
      code. Normally, a compiler would remove unused static functions or
      fail to expose them in object files, which could prevent the BTF
      ID generation logic (`resolve_btfids`) from finding them. However,
      the `__bpf_kfunc` macro expands to include `__used` and
      `__retain`, which strictly instructs the compiler and linker to
      preserve the functions in the object file regardless of
      usage. Additionally, `resolve_btfids` and `BTF_ID_FLAGS`
      successfully parse and resolve `STB_LOCAL` static symbols, making
      this change completely safe and correct.",

      "locations": [
        {
          "file": "mm/bpf_memcontrol.c",
          "function_or_symbol": null,
          "line_range": null,
          "why_this_location_matters": "This applies to all the
          functions modified by the patch."
        }
      ]
    }


Thanks

