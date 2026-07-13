Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7190C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 08:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06096B008A; Mon, 13 Jul 2026 04:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6C46B008C; Mon, 13 Jul 2026 04:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACD1F6B0092; Mon, 13 Jul 2026 04:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85EAA6B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:07:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED38D140A59
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:07:43 +0000 (UTC)
X-FDA: 84983024406.05.6970E96
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf27.hostedemail.com (Postfix) with ESMTP id 83FB44000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:07:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783930061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lL0ghfdnn3pMEkN99GF4Hoa+KUimoaTTxYIOM64MmqE=;
	b=WmTJSdfOsolpXL9hgdINYBZCMcGA+QR5UFuielcmd3P6+dC3bJA8fIXuKgZNANVEY98Npl
	VlNgxRxcdd+4x+E5N5tNb/RcSrQKlooWtF6gC6fW7DUGSOzsLFpNhzD5hzvBiHGtZTQo5r
	sepqKduGQsfIKjfkRxhcOa6DIibgQMQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783930061;
	b=kkirBnAs00JgvW7s9aAnUNGXKvZUYxtC9XXjOl+VDInlVGlfMb66K5JHyzTa2T+24Kf+ta
	6txTD4FVdyjNCM7PySRkVlt430Vu3IjFsI5Xg3LfnevO/Ee3iCRGhB60rjHFSf15OBJyhb
	lxxhw+wIoXOpMEn4CisRhk9WGISQbJQ=
X-UUID: e4b980427e9111f1aa26b74ffac11d73-20260713
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:8510d1b2-93db-4ac5-9dc9-65b52762d741,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:8510d1b2-93db-4ac5-9dc9-65b52762d741,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:61bc83918cbb5abf98736792a1823c7b,BulkI
	D:260708211528KWIAZP6K,BulkQuantity:5,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|841|865|898,TC:0,Content:0|14|50,EDM:-3,IP:-2,URL:0,File:nil,RT:n
	il,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: FB4AE12C3614FA9BCB7C5D5557923902
X-UUID: e4b980427e9111f1aa26b74ffac11d73-20260713
X-User: lihongfu@kylinos.cn
Received: from [192.168.109.123] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 821774626; Mon, 13 Jul 2026 16:07:29 +0800
Content-Type: multipart/alternative;
 boundary="------------2LaW5wAKxX9pdAc6BMPK0AAI"
Message-ID: <1c0644c0-36e4-454b-adf0-47845036b39d@kylinos.cn>
Date: Mon, 13 Jul 2026 16:07:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix memleak in migration benchmark
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org,
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 hongfu.li@linux.dev
References: <20260708103705.840679-1-lihongfu@kylinos.cn>
 <alHxLNTQFJlb3cLV@lucifer>
From: Hongfu Li <lihongfu@kylinos.cn>
In-Reply-To: <alHxLNTQFJlb3cLV@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83FB44000A
X-Stat-Signature: kgziy944cghcqaq1bmt6xirz6jrh1a4i
X-HE-Tag: 1783930058-602630
X-HE-Meta: U2FsdGVkX18OnO4gSDS6XfG1q51wBi/XxWqjIPAijtjcoFOMnsOB7KNQE+1nFseNcdyJWtXB98hDmZci37Vh91koy4qMuYLOOCbQn2rjQXptP+MgyJH97/Fc6eIyMjaYVaOi/6NolmhEvJuHNeXh1nAdlAEH1C72I2wlADq4NWP4RslCNZur7TpTozKE2y1FqfAS4XBXp+c9gSchVmcQUih8odm/2x29kKErN4oTZ9tAbJ08B7Q2gRg9dd8SYD00Kmzd6bCKTKV94wlAX75nTWPPCGI+fLqa+JIZWYeC+WbTvLsbciwSP4nnNzhx1/4pWHNSCdLYgeh9ZEXIba3HOpoBZ8k40TPxGPD2xUwb6cfR+6CmzKJHb3XEzVyoEEe3YzOFv5O6FGYtERtBQA0RinrErzHET1zOx6n3g/L+HPCV2PNW2OK1WlVUbNRbx2hY/jegnulS5kPBXeyzE66716Q8jj6thn+wJAnIzJVhKHSaB7l36w0Y/y4OTm55tHFzw1VuSZPBfskGwZoH5tAlCsSz+01IvOdOHvAznUtbmc5QuJOx//SY95inbnHJ4w2oXUX5DifoaJR9qLvNY/T3wR0gRismLoKKwMGrLOjPNPT/J/zzZzyzykQoInS9uR9PiBPxOLUCPPr6ycbGg7Ec/lD0TJ9BytVY8QIVN/x24cb+a1F3h8LOBbXJTK1LUi813sMTciqeB84/XH6gqYUCrrLJ4L9lWIGluqLEFv1xswW+wOUNzAKSMLDliJWEqU98BhEHOy0OWlRC/7vqnJHcLUTIf4z53DpXy99f6AvTPVO4CovqnIR7sGrmSMtwlDTqeaRwpOxPqGBKd5aGqA8BP2UJaPIGBmeJcWZGBgV/CakxRoASyj+Gc3l3m2r4Jv7ycwcux1/qlFOw0bWKsciLne6XR2phN8+nfgYFwIZGg/UAeO+u/A2SIr4v8AqWkHw6FmK/MIp3+xs7Rbzs5iq
 R4u/d7SK
 8ROegrMvqgA7U+miJVPc/7DHb4E7nF0GLUY9ksR4fxhfU+gtWvYIq1LEW5buk3pElP2jPuGVXuF5ARWe2uPYjlbUvIUVTPOHV/+RW4Xm2ubPMGP6gLea+9t8TawHghc9BzgR9OtHRIBcc5qJJ8rZvQR92D80jOOqIPE4TDokbkMA/TDtQFQFHgW56Hof4MrqDQMZ/KfEzdLWJdCLA1JV+K87LnnrsaA7VXdrNnHiTf7e1prNkNCakPubEO6pIGUiR9xm7Z9L/wz2lZ/RIV5YH8uPNny9JjMhqakOD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------2LaW5wAKxX9pdAc6BMPK0AAI
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, Lorenzo

On 7/11/26 3:31 PM, Lorenzo Stoakes wrote:
> On Wed, Jul 08, 2026 at 06:37:05PM +0800, Hongfu Li wrote:
>> Several early return paths in run_migration_benchmark() skip
>> hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
>> label.
>>
>> Signed-off-by: Hongfu Li<lihongfu@kylinos.cn>
> LGTM. With the Fixes tag added as requested by David, feel free to add:
>
> Reviewed-by: Lorenzo Stoakes<ljs@kernel.org>


Thank you for your review.

As suggested by David, I have added the Fixes tag in v2. The patch
has now been applied to the mm-new branch.

Since the patch has already been merged into the public branch, I am
unable to modify the commit message to add your Reviewed-by tag
after merging. However, I truly appreciate your review.

Best regards,
Hongfu


--------------2LaW5wAKxX9pdAc6BMPK0AAI
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p>Hi, <span style="white-space: pre-wrap">Lorenzo

</span></p>
    <div class="moz-cite-prefix">On 7/11/26 3:31 PM, Lorenzo Stoakes
      wrote:<br>
    </div>
    <blockquote type="cite" cite="mid:alHxLNTQFJlb3cLV@lucifer">
      <pre wrap="" class="moz-quote-pre">On Wed, Jul 08, 2026 at 06:37:05PM +0800, Hongfu Li wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Several early return paths in run_migration_benchmark() skip
hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
label.

Signed-off-by: Hongfu Li <a class="moz-txt-link-rfc2396E" href="mailto:lihongfu@kylinos.cn">&lt;lihongfu@kylinos.cn&gt;</a>
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
LGTM. With the Fixes tag added as requested by David, feel free to add:

Reviewed-by: Lorenzo Stoakes <a class="moz-txt-link-rfc2396E" href="mailto:ljs@kernel.org">&lt;ljs@kernel.org&gt;</a></pre>
    </blockquote>
    <p class="ds-markdown-paragraph"
style="margin: 16px 0px; color: rgb(15, 17, 21); font-family: quote-cjk-patch, Inter, system-ui, -apple-system, &quot;system-ui&quot;, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Open Sans&quot;, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"><span
        class=""><br>
        Thank you for your review.<br>
        <br>
        As suggested by David, I have added the Fixes tag in v2. The
        patch<br>
        has now been applied to the mm-new branch. <br>
        <br>
        Since the patch has already been merged into the public branch,
        I am<br>
        unable to modify the commit message to add your Reviewed-by tag <br>
        after merging</span><span class="">. However, I truly appreciate
        your review.<br>
        <br>
        Best regards,<br>
        Hongfu </span></p>
    <p><br>
    </p>
  </body>
</html>

--------------2LaW5wAKxX9pdAc6BMPK0AAI--

