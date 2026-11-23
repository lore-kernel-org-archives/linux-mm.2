Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68240606A33B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D6Fh9qWC
Received: by kanga.kvack.org (Postfix)
	id 6D4D26B05B5; Mon, 23 Nov 2026 03:24:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6847D6B05B9; Mon, 23 Nov 2026 03:24:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5730B6B05BA; Mon, 23 Nov 2026 03:24:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CFCE6B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:24:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B125040836
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:24:33 +0000 (UTC)
X-FDA: 85465697226.20.F745635
Received: from mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	by imf11.hostedemail.com (Postfix) with ESMTP id 78AEB40009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:24:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D6Fh9qWC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795422271;
	b=xtxUDlzhcaWcn7vZT4IBhQwkcmc3tb3OYDCdGll+VV7gP+PILYCRBgy9D3WVBMZQsIRIJw
	9SvJI0t2sCWTDhze27ZssKjbT/JuaL6fTAv/xThuWMI5zegA3tUlzh3B6w+mJ3N+ho2j8/
	WX4amMh0oa/LnSbxHwd/W2/nzqZAzGo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795422271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQO4tn0OyPdxMhtPAGNESRuXYu8NbrwjcIpFVzP0og8=;
	b=5W0I3JY8+fm4dmfyLffaA1y/U5mClT42F/nGtv8SAPpHD8wmN3aDzMvxraP8Uzm7Ue4K6e
	QKVpcs0ErdQ1AiF25lehaqS6WXqgV8DizoPP2ouA7srW3mKFl2eUr4aAPHpxCglZi+nGiO
	c6gRbu3mo2N9cV2RGclLpoeu+ounCzo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D6Fh9qWC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HSUyFp+EYllNTrLsXxEGxRMBuqpbPPoIyuQ1COVxKsE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795422270; v=1; x=1796027070;
 b=D6Fh9qWCPEswhAg5emIFm6DBkMe74EM6ay3Mi3HuZUBJNeGqHpWo2PZ+RBhuA+TCw7/pdfYM
 fNbX7Sep8iwoCOQFiu1FXC9I/doZUWoDJV2AXczIR6+kywooOFjb3+eDPROR5/ViWJePvPi3DFO
 GXwYoS62jRK5yXqQteoZ2vmM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4f28e3a27007a1d5;
	Mon, 23 Nov 2026 08:24:29 +0000
X-Mizu-Trace-ID: 4f28e3a27007a1d5
X-Migadu-Flow: FLOW_OUT
Message-ID: <1e7d39f1-382c-49e2-b3ae-935f25b22a57@linux.dev>
Date: Mon, 23 Nov 2026 16:24:23 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/11] mm/vmalloc: reject an unaligned range in
 __vunmap_range_noflush()
To: Suren Baghdasaryan <surenb@google.com>, Dev Jain <dev.jain@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-5-hao.ge@linux.dev>
 <4c233641-15ad-4e5a-a106-423bc31f357c@arm.com>
 <CAJuCfpG5shRGvjHJyEOveSxkPE=x7nGTo4xmy0XLabV7NutrMQ@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpG5shRGvjHJyEOveSxkPE=x7nGTo4xmy0XLabV7NutrMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 78AEB40009
X-Stat-Signature: i7hqp5xrpnmxhy5qh9e9z7exhyxoj1wn
X-HE-Tag: 1795422271-598886
X-HE-Meta: U2FsdGVkX184L3JfK7l783BfmvHMDFjhxoopNokZdI9qxUVaUdmKM/jDUFrLOjnVsBV7YIiFdI1DEQyPhlJwC/Fsdggzhm2ApDPNahs0YRTAt5Z3kPJ6PCzvr9LzEN8W8pXxeGCuZfU8GxALqwUo814Zr7ofMX2ovNa9vScYhVvTJmzAowNtIXq0UU+EERQqAeto/7qj+03MYqtTtYxEzYvlGl9ZNRciz5Qa5i+ErCUFK6JY0/+WnIZeRaiDTt4y0fg2HK88Rgck1tSudRSNrOQtKfZnXqd5bv2M6MgGzesxn89r9vOQ3Y0ENcHHLxbRC8Jna5GNhwhh74dTZDmYUuRiPar2jW08wSUSctkktDuXKUANJIigqcZShr3gzo/euFDPfUMQxTtxj72kDPAw94BDiLKq/Uhu1JNzX5L6AY/hj/f6n2Vdqxp80Yxc7/Hk7BznhA2SCSH0fKyLhN5oVlcV1gDL9qgfuOjthy+7k7Zk7NvJ5ANOkoK6rsE7+w4iHE/x1hSz9EBzvUMOuZay/KaJ1lUkLsCPRlI2n6/gA3zZwh1kqC2kdRR2nGRMzi/6XyrZ2jcyFizDr5t/YXMPXoIcREFTRzvH2bBWP80EuPviga+G6ENVhOMHwXf7EeLRJjMbaXpDKsw6l8S4nEGRYEvBFdOkW4a2j7BtXssKKGf7F20ygtDN7l2sWpUvUiTqvQ2eQtiaEqOc/zo5WNW2XV82FGKqB9cEKgOAgz7bVtDvv4uFoXw3WBxj+/Sm1zw9qlI1DWzdWzXyW8dAqOqNXZ+1fhguCh+FN8gCKYqV+fBtUAq0UpcJlJ4ISDKac/jLHh/kyeFiwpWh67MfFduNWAJL2x179JGCpCM52V1cEQCWzW40c4bwmIjDQ4o+ce49v+HBBEZfjAH1v1nKGNHA38mYqgrjoaTZxQ0mwclGxIyPeWYVNpj21fhUk30pLKkvyz9A4cLrr55bmiaA0zc
 C+zs0H+q
 fCpAuWbuY/cwomQ99/WLV84MXpKPTFT0wt45H+4+DmSAnR9lc18b5PY+eo4efWArUVoBUD3eNCDdi9TVV8j8EMe1b+94boJmgofYfTgenj+5T8bAcYV2INpNVeu8E7DmyvAbo5M/ZVZ0vd7BDtgezE1yUUrqXa5QJ7pYiFg70MBaN4WQ3iXSTL6PDGQ6Dp4CxLsfNxkZKaYxiDapHDg5TwsnyYP+9PnXW1QgiOjTh5/qlGwjxlzGRG5GlpyqsXivM0bux0A1ZB75tMtWXf3vUIPm9oWEGj+9/7hciaDSKtvvEA2Zxoia+25toHA6Na30pmYSdweZtCMJTmZUCTvnzgIm55cjNPH7o48iINOoPuIIdsQfVFeJWk5Qu95hxgnYbEPMsQ8vhLIp4lc+f80UC+cKb3/TkD+vaJ76XNejREUDZ2t11C6oHJs6sR9iP+zpPNCfVGoC88MP6ozaCk7+OeFOzwVWFSHJzq60sqA+Y1H+P98+pQs0033L03EJA2J+b8gpFsHCHvOg1Za9BpSoJj4QP/J6+vNrQD6Uzd1PfsDAYcgRrdemA4Qq3Dw8cRRB/1W7qXV0yOYSk9RBGlWwmbcviLogrM9bO2FYOuqMNofSKr874J/8BCdsFtlonVU6zOz+Atng2lmAHAwVgrNdzsISP1cMglp4xqf6sYnYEwDV89jyitJ/rIXTPDZ5AlqAM2G7yfwuwLOKATSiVY9fqUcdtTNwYFMujlyeyaMRbmoV+F6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Suren and Dev

On 2026/11/21 06:13, Suren Baghdasaryan wrote:
> On Tue, Nov 17, 2026 at 6:05 AM Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 16/11/26 12:43 pm, Hao Ge wrote:
>>> The PTE loop stops only at addr == end. An unaligned end is never
>>> reached, so the loop keeps clearing past the range. An unaligned
>>> start clears the page below the range first. Both are caller bugs,
>>> and the damage is hard to attribute afterwards.
>>>
>>> vmap only installs page aligned mappings, so an unaligned unmap
>>> request is never a legitimate teardown. Warn and bail out at the
>>> entry of __vunmap_range_noflush(), before any PTE is cleared.
>>>
>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>> Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>> ---
>>>  mm/vmalloc.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index a168f6f20f4f..e2b63cb1592b 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -523,6 +523,9 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end,
>>>       pgtbl_mod_mask mask = 0;
>>>
>>>       BUG_ON(addr >= end);
>>
>> Nit: It is usually a practice to change the existing BUG_ON's to
>> WARN_ON's too, if you are changing around that part.

Ack.

>>
>>
>>> +     if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
>>> +             return;
> 
> nit: It's also better not to combine multiple conditions into one
> warning so that the generated report clearly shows which condition
> (code line) caused the warning. IOW:

Ack on applying the same to the previous patch in the series, "mm/vmalloc:
reject an unaligned range in vmap_page_range()", as well, it is done the
same way there now.  

Thanks
Best Regards
Hao

> 
> if (WARN_ON_ONCE(!PAGE_ALIGNED(addr))
>         return;
> 
> if (WARN_ON_ONCE(!PAGE_ALIGNED(end))
>         return;
> 
> 
>>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> 
>>
>>> +
>>>       pgd = pgd_offset_k(addr);
>>>       do {
>>>               next = pgd_addr_end(addr, end);
>>

