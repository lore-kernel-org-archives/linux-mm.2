Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E67CBCEACFC
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 06:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF8DF8E001F; Sat, 15 Nov 2025 01:59:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8F88E0005; Sat, 15 Nov 2025 01:59:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBFC58E001F; Sat, 15 Nov 2025 01:59:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC0C18E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 01:59:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FBE5BAAA2
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 06:59:02 +0000 (UTC)
X-FDA: 84111939324.16.7BC1708
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA397C0003
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 06:58:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763189940; a=rsa-sha256;
	cv=none;
	b=t2Rr4KWEQVGJpeW1fRJEsmZLuz2TEcgdbwU0ekyBYrDersKCyBi2GxD7G+YAM7zqY6CF8g
	wI5lfEHepFaN6CiBR9gqQSGyg1T6lunnNAe5Y5p6Sh79T4a0klDhPxgD3xWa5fjg3vLaZg
	rZuvoPyXDrhEdVFIIna9Ct0Mhxl5nYM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763189940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hBdc4GfvVBfLjLHTqmm1y9yOV6OV75Fod+MPDBYEl0A=;
	b=jUtQq5tLlPECyr1U62S6dTqLAlyb5KHuZZOXZDmuKNP1L9b5DVP0VTIPHGQ8pUQ36We5Yr
	howkMfHZ+fcbkz6S+N9mz+r1ALXkG5Pt+LsnXa/Iuznm25ygZQL6FiQLVEssLQWCLeX/xi
	+bE1Q7ueb8KuGOF4i3nGgUC1Mp+YRZo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 521201063;
	Fri, 14 Nov 2025 22:58:51 -0800 (PST)
Received: from [10.164.11.1] (unknown [10.164.11.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 251113F66E;
	Fri, 14 Nov 2025 22:58:55 -0800 (PST)
Content-Type: multipart/alternative;
 boundary="------------rX7B232xc21hQHL1v0kVFzn0"
Message-ID: <aeb5ec99-11b3-4c77-8a04-469faab4210a@arm.com>
Date: Sat, 15 Nov 2025 12:28:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Hit an assertion within lib/xarray.c from lib/test_xarray.c,
 would like help debugging
To: Ackerley Tng <ackerleytng@google.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: david@redhat.com, michael.roth@amd.com, vannapurve@google.com
References: <20251028223414.299268-1-ackerleytng@google.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251028223414.299268-1-ackerleytng@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EA397C0003
X-Stat-Signature: m3b5x7woud456e9uzf3rnbyrek7x13wi
X-Rspam-User: 
X-HE-Tag: 1763189939-459880
X-HE-Meta: U2FsdGVkX18h1U2ngv9k0iFcHSY+JuOUWnhJbeeFPd8xKBliphnIKCk4+MKov6xN9o+O0bRyAQ7CK8G5iRX3S5WyG4cVF2+U/eiPq4W5fhVpq26zcfngfcJ6ORNEILhjOPQ2RkHTXSc0rDusoxIi9t6BueamzGQpZyeQvGSnwEGXThCKULQDDZrfqxVRn0nsVYFgWb2qKaO0OxnGWlQAJJMOk+FPX+Ajkkq26V+yL4eOrRnywhS0AuXFpwbQH7zpZnq6FCmiWZ1Ilt21yiZ8BMcSdirxHConAbRlLzeyqln6HMgK6ZjkPH5UUX6f3VtT+BTuELCJlCWhPf/Jr+fRqvUZP5pvxzyLEfF+VhN1y5RvR4FOanIXFf18aHtlh7T6v/sTmVQags/9lS1zR84Puyj8/fewUwQM6FVT3bMdboNL6//S0tkKE/hoKQiFxAN6BEoavYCeUp9lhx2XNbnkpRiAMymk829I511zc8w+bUcwX68JrzqyrXFawogl7jplcCowUpQfIE5/JgLQRQR7WAAfk7CTwGrVvcUJyYLbLD98dB8PQf5Z07rn1vG+2Jq8UTtMSBqglvBbyqi8eVtlu1dJCd1zAD6GhtGSz8pPdlEsBuEiaVVdWZD9zMAeEwipyiFjqvqsUITGSN9Sw6Zv1zPhXNo56R/5RnmluBppIucjsZD5W8kefJJgE8581hP3yzDlRZ9et7NTyPKDrHwCXA0L97naFVZNEOW/kf4735+ajxkhVnz12DoH8cULt5d9792y4C3a4BI22DVYsqSyFGQmAoPoLK4TE8PbfvmsThGalHjLPaJeO90y6E5ygZ9QyTzVzjCNbh8ju2rEl0dUy69VKRzfWHtKZomupBY4PjOoBuADzztq0BXEsyWyyi8p9aM9sB2QlQngm0dyqjTlLRookSKPTmN4/pne7zwSsCDuNJUxmUaGd1/TAJFyD8l8FqbqmbQmZXArSiuEsyf
 K8yMrOL2
 Ha0QpKIg55VFJjFbbjspfSsH2vFwD5g0wsO2TKxjraO/rbZVAhFsC4aMyX4gisrDRWjAhyXSrO3cKHQSpoTYkzibIfubmYGav/NyyIM9zf6+P2DFCbQPe+AklG0n32z4lSZsR+q4gRtNbm/t05g1YxSZUfJOkvD6/Vziextku5s2q1qEby97yiuVmI3J2wecBo9gqVI/Bye3w+CuYUNDOt68BYK1kN16RLAoCdGYsNHv8YIL5XoKjWnFWfIf7Dggr+iGhIxswK+LRmIKV6HNmsheb5Jsy+Y0DOjWhi1CbC3SzmZgcwreoej1hfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------rX7B232xc21hQHL1v0kVFzn0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 29/10/25 4:04 am, Ackerley Tng wrote:
> Hi!
>
> I'm trying to use multi-index xarrays and I was experimenting with
> test_xarray.c.
>
> I'm trying to use xa_erase() on every index after splitting the entry in the
> xarray. (and I commented out every other test case just to focus on this test)
>
> Should erasing every index within the xarray after splitting be a supported use
> case?
>
> Here's the diff:
>
>    diff --git i/lib/test_xarray.c w/lib/test_xarray.c
>    index 5ca0aefee9aa5..fe74f44bbbd92 100644
>    --- i/lib/test_xarray.c
>    +++ w/lib/test_xarray.c
>    @@ -1868,6 +1868,9 @@ static void check_split_1(struct xarray *xa, unsigned long index,
>     	rcu_read_unlock();
>     	XA_BUG_ON(xa, found != 1 << (order - new_order));
>
>    +	for (i = 0; i < (1 << order); i++)
>    +		xa_erase(xa, index + i);
>    +
>     	xa_destroy(xa);
>    }
>
> And made a call to
>
>    check_split_1(xa, 0, 3, 2);
>
> Here's the assertion I hit:
>
>    node 0x7c4de89e01c0x offset 0 parent 0x7c4de89e0100x shift 0 count 4 values 254 array 0x55edd2dd8940x list 0x7c4de89e01d8x 0x7c4de89e01d8x marks 0 10 0
>    xarray: ../shared/../../../lib/xarray.c:764: update_node: Assertion `!(1)' failed.

I changed that function to the following:

staticvoidcheck_split_1(structxarray *xa, unsignedlongindex,

unsignedintorder, unsignedintnew_order)

{

XA_STATE_ORDER(xas, xa, index, new_order);

unsignedinti;

for(i = 0; i < (1<< order); i += (1<< new_order))

xa_store_order(xa, i, new_order, xa, GFP_KERNEL);

xas_lock(&xas);

for(i = 0; i < (1<< order); i += (1<< new_order))

__xa_store(xa, index + i, xa_mk_index(index + i), 0);

xas_unlock(&xas);

xa_erase(xa, index);

xa_destroy(xa);

} and I still hit the assertion. I think the new function is still a valid code sequence -
Store multi-indices of new_order, for length = 1 << order.  Then, replace those entries
with xa_mk_index(index + i). Then erase the first index.

>
>
> I think I've narrowed down the issue to the for (;;) loop in xas_store(), which
> I believe isn't counting the `values` to be updated in update_node() correctly.
>
> Is `values += !xa_is_value(first) - !value;` intended to compute the increase in
> number of values with replacement of every slot being iterated by the new entry?
>
> Why does the computation of `count` involve next and entry, and why does the
> computation for `values` only statically depend on the initial value of entry,
> and on first instead of next?

Yeah there is some issue here only - but the code seems to work, tried a lot of
different combinations in my head like throwing out a non-value and putting in
a value, then vice-versa, then putting a NULL entry - can't figure out the problem :(

>
> Thanks,
>
>
> Ackerley
>
--------------rX7B232xc21hQHL1v0kVFzn0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 29/10/25 4:04 am, Ackerley Tng
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20251028223414.299268-1-ackerleytng@google.com">
      <pre wrap="" class="moz-quote-pre">Hi!

I'm trying to use multi-index xarrays and I was experimenting with
test_xarray.c.

I'm trying to use xa_erase() on every index after splitting the entry in the
xarray. (and I commented out every other test case just to focus on this test)

Should erasing every index within the xarray after splitting be a supported use
case?

Here's the diff:

  diff --git i/lib/test_xarray.c w/lib/test_xarray.c
  index 5ca0aefee9aa5..fe74f44bbbd92 100644
  --- i/lib/test_xarray.c
  +++ w/lib/test_xarray.c
  @@ -1868,6 +1868,9 @@ static void check_split_1(struct xarray *xa, unsigned long index,
   	rcu_read_unlock();
   	XA_BUG_ON(xa, found != 1 &lt;&lt; (order - new_order));

  +	for (i = 0; i &lt; (1 &lt;&lt; order); i++)
  +		xa_erase(xa, index + i);
  +
   	xa_destroy(xa);
  }

And made a call to

  check_split_1(xa, 0, 3, 2);

Here's the assertion I hit:

  node 0x7c4de89e01c0x offset 0 parent 0x7c4de89e0100x shift 0 count 4 values 254 array 0x55edd2dd8940x list 0x7c4de89e01d8x 0x7c4de89e01d8x marks 0 10 0
  xarray: ../shared/../../../lib/xarray.c:764: update_node: Assertion `!(1)' failed.</pre>
    </blockquote>
    <br>
    <pre wrap="" class="moz-quote-pre">I changed that function to the following:

</pre>
    <div
style="color: #000000;background-color: #ffffff;font-family: Menlo, Monaco, 'Courier New', monospace;font-weight: normal;font-size: 12px;line-height: 18px;white-space: pre;"><pre><span
    style="color: #0000ff;">static</span><span style="color: #000000;"> </span><span
    style="color: #0000ff;">void</span><span style="color: #000000;"> </span><span
    style="color: #795e26;">check_split_1</span><span
    style="color: #000000;">(</span><span style="color: #0000ff;">struct</span><span
    style="color: #000000;"> xarray *</span><span
    style="color: #001080;">xa</span><span style="color: #000000;">, </span><span
    style="color: #0000ff;">unsigned</span><span style="color: #000000;"> </span><span
    style="color: #0000ff;">long</span><span style="color: #000000;"> </span><span
    style="color: #001080;">index</span><span style="color: #000000;">,</span></pre><pre><span
    style="color: #000000;">                                </span><span
    style="color: #0000ff;">unsigned</span><span style="color: #000000;"> </span><span
    style="color: #0000ff;">int</span><span style="color: #000000;"> </span><span
    style="color: #001080;">order</span><span style="color: #000000;">, </span><span
    style="color: #0000ff;">unsigned</span><span style="color: #000000;"> </span><span
    style="color: #0000ff;">int</span><span style="color: #000000;"> </span><span
    style="color: #001080;">new_order</span><span
    style="color: #000000;">)</span></pre><pre><span
    style="color: #000000;">{</span></pre><pre><span
    style="color: #000000;">        </span><span style="color: #795e26;">XA_STATE_ORDER</span><span
    style="color: #000000;">(xas, xa, index, new_order);</span></pre><pre><span
    style="color: #000000;">        </span><span style="color: #0000ff;">unsigned</span><span
    style="color: #000000;"> </span><span style="color: #0000ff;">int</span><span
    style="color: #000000;"> i;</span></pre><pre>
</pre><pre><span style="color: #000000;">        </span><span
    style="color: #af00db;">for</span><span style="color: #000000;"> (i = </span><span
    style="color: #098658;">0</span><span style="color: #000000;">; i &lt; (</span><span
    style="color: #098658;">1</span><span style="color: #000000;"> &lt;&lt; order); i += (</span><span
    style="color: #098658;">1</span><span style="color: #000000;"> &lt;&lt; new_order))</span></pre><pre><span
    style="color: #000000;">                </span><span
    style="color: #795e26;">xa_store_order</span><span
    style="color: #000000;">(xa, i, new_order, xa, GFP_KERNEL);</span></pre><pre>
</pre><pre><span style="color: #000000;">        </span><span
    style="color: #795e26;">xas_lock</span><span style="color: #000000;">(&amp;xas);</span></pre><pre><span
    style="color: #000000;">        </span><span style="color: #af00db;">for</span><span
    style="color: #000000;"> (i = </span><span style="color: #098658;">0</span><span
    style="color: #000000;">; i &lt; (</span><span
    style="color: #098658;">1</span><span style="color: #000000;"> &lt;&lt; order); i += (</span><span
    style="color: #098658;">1</span><span style="color: #000000;"> &lt;&lt; new_order))</span></pre><pre><span
    style="color: #000000;">                </span><span
    style="color: #795e26;">__xa_store</span><span
    style="color: #000000;">(xa, index + i, </span><span
    style="color: #795e26;">xa_mk_index</span><span
    style="color: #000000;">(index + i), </span><span
    style="color: #098658;">0</span><span style="color: #000000;">);</span></pre><pre><span
    style="color: #000000;">        </span><span style="color: #795e26;">xas_unlock</span><span
    style="color: #000000;">(&amp;xas);</span></pre><pre>
</pre><pre><span style="color: #000000;">                </span><span
    style="color: #795e26;">xa_erase</span><span style="color: #000000;">(xa, index);</span></pre><pre>
</pre><pre><span style="color: #000000;">        </span><span
    style="color: #795e26;">xa_destroy</span><span
    style="color: #000000;">(xa);</span></pre><pre><span
    style="color: #000000;">}

</span>and I still hit the assertion. I think the new function is still a valid code sequence -
Store multi-indices of new_order, for length = 1 &lt;&lt; order.  Then, replace those entries
with xa_mk_index(index + i). Then erase the first index.

</pre></div>
    <pre wrap="" class="moz-quote-pre">
</pre>
    <blockquote type="cite"
      cite="mid:20251028223414.299268-1-ackerleytng@google.com">
      <pre wrap="" class="moz-quote-pre">


I think I've narrowed down the issue to the for (;;) loop in xas_store(), which
I believe isn't counting the `values` to be updated in update_node() correctly.

Is `values += !xa_is_value(first) - !value;` intended to compute the increase in
number of values with replacement of every slot being iterated by the new entry?

Why does the computation of `count` involve next and entry, and why does the
computation for `values` only statically depend on the initial value of entry,
and on first instead of next?</pre>
    </blockquote>
    <br>
    <pre wrap="" class="moz-quote-pre">Yeah there is some issue here only - but the code seems to work, tried a lot of
different combinations in my head like throwing out a non-value and putting in
a value, then vice-versa, then putting a NULL entry - can't figure out the problem :(

</pre>
    <blockquote type="cite"
      cite="mid:20251028223414.299268-1-ackerleytng@google.com">
      <pre wrap="" class="moz-quote-pre">

Thanks,


Ackerley

</pre>
    </blockquote>
  </body>
</html>

--------------rX7B232xc21hQHL1v0kVFzn0--

