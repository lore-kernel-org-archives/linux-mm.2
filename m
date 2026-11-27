Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547FF606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 03:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mtaOhat+
Received: by kanga.kvack.org (Postfix)
	id 75A4F6B05B0; Thu, 26 Nov 2026 22:10:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733106B05B1; Thu, 26 Nov 2026 22:10:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66FAA6B05B2; Thu, 26 Nov 2026 22:10:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46E556B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:10:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6D261A0109
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:10:33 +0000 (UTC)
X-FDA: 85479421146.16.6B1C06D
Received: from mta0.migadu.com (out-229.mta0.migadu.com [91.218.175.229])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E97380007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:10:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mtaOhat+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.229 as permitted sender) smtp.mailfrom=enze.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795749032;
	b=Eoheih4Xue7LbKd6XcGNRF9W1+78S5U5RsCR4GTIx+y3AUCU6qsyPWNDH+YdUU5cPLa8cw
	Rljoe5SVa8iv5eJlA8rrFwFCtJRvvmDCOYLNWhWnixgJ9smGysotFvI0sVIm+yilSyINbX
	0erkssCI6kORCJVb353j7TnaN7ED/Ys=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795749032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbzZRC8GZ/f3CACyJdYhK6Qx0PIpPkYatenSOSwlUi0=;
	b=blwrjdgewOilxn09jYAztuHGzBWDgCPP2i6Hesf/jsV8LqfYyaFoOgTH3ZWGrb9IP53vQg
	ZSFzY6psTu/tfEBUypkMKRhf6PV713vqE53fkr2UYkTe0LfTQDjNey7YCeIoYcqXeYSnHv
	6XwObGFi0HWpU8I5Kpk67lTN1zYKxmA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mtaOhat+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.229 as permitted sender) smtp.mailfrom=enze.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5Gapfe3JePo/kAodLwmJ/LTyHDjI+QlZE8NLOsmgOt4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795749028; v=1; x=1796353828;
 b=mtaOhat+tmGIRwpphrx3PT/wwZ4ZKOXdVuSnHJYeMyr8vlSdyK5tx+7WOwlykHBst0np8Yx0
 60dhuwPTEG5WIxEJQM1uKf66sL0NCQLCYGfDzwWc1/RVzY+vdG51v4mbbW3uNetmh1iY924yrAV
 GUMP+CDxa/7GchdbLy/cARSU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a204e3fea644232d;
	Fri, 27 Nov 2026 03:10:27 +0000
X-Mizu-Trace-ID: a204e3fea644232d
X-Migadu-Flow: FLOW_OUT
Message-ID: <d768efa0-60ff-4f87-aa2d-07bd49a6c150@linux.dev>
Date: Fri, 27 Nov 2026 11:10:11 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/27] Docs/ABI/damon: update for report producer sysfs
 files
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>, Lian Wang <lianux.mm@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-12-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-12-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: i3oyjpkamie4s3biiasghptjtyzr5xnk
X-Rspamd-Queue-Id: 4E97380007
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795749030-731791
X-HE-Meta: U2FsdGVkX19nnZ7dI6T2kq2Q9UXeMDwpbHaPFHuAxzAglmwpK4hLdKmZxfGz97iygzeLjrPOGXO2HXyHoe5L99bVW6sPuIU/ej3wlCHwx33Xui4r4oLb/aOUaDbg2lA5PagrJewJH7ealx/y0oempWrtxZr735nkFNrvMcetinp4mYBBe61HYkkXedrAIP1LhJD6faZWnopbE1zNksu5U8LYL2pgjko1uAbNX1t7+qKJVgDdlTGi3Ge0Iq7YPVW6/slC18O1zE/RptQTDtEP/+iB/EQ3D6nNcQHn6J2CwRrAlqlOR3PPsAQXo4N/XlXBEELxhow/wAohIrmTBAi5eW/YbZ9y0CMvMy1vQ1lUsoxP7ukFl9yBCTPh/kMPoqSOmlPNnfmOwdixLaSWvCmrbI2fdcTkkP6+WHt2TZVDyMDlP94VTG7P+2LHHvPtTdAblro+w2f+A/nNXt22lprIEI4Ay/kLQ2SgcESUadVbolsFlWEvjAbAw3Lhrc6ThdQxY+usIoZ6D8vgnyRsggVQkouThbICraYt9johJv4Dh0UjJHJaZTuet22473r8t0Z6TR2efx7o4uYPwcwpCce0lp2qb0y3jmzjG2x634JnN2dJezMyZOMFghIqa1ne6b2WrVprDd2aykUbVbCWxuw0OGS9flbJUy0ziFT/aS41cm1yEcrc2r7JJn03Epa94qwxYj2dBOtGDwkAGd0+U+s1KshpHyxCNNzDy9U8ssvddIIBgIOLtNnGJowTiwyV156+/5vA86XtmgQIl7IBq+OQi+UP+BeIm5VOKiNpax+cDHITBQl9RWy58eJI0ajf6AEyi9pnrcWvpz20dni/mtyEzGylFji5p23ghCIb8A9KEIyoN2PqOMjv2PQKX2UJQUVJEysekwubre+qYaieYmZtnW5ZeOjTldYHSsR0ZizYusvR2g7TwwCW9nt6aOpQh/+HrIQ9dB86EKD4/hVv5zk
 14ABIBIu
 020TXG66fGRIFZLndqgiApDSWXar2RAT8kDOOJkJkVDeCQ1aQzD/SGwF3GAFzF4+8wAZyUGeLovWeyjxMwk4E/MG050YA8yE2t4Np3MoAVyPkaaU1IMI/1TMeKZvQPkFiVkEPYmQMpe7ZLwOSwLrXVLq4G93UapxlkhfuYjpvPq0fqfwj9Uk/PLj4UpKAHgDxO2DPaLf51fL4Y7xNjPowfqCr+XQhs70rnyzxkUt/7h1iFXBFQdR4msiMteB0y+os2tKEJgOwG6njUYWrS4eRgTX1TDeBWhXcgGwS6xauNg8DOPRTX0Yhg22f8+GWkkGYWb67qJBZ/2JxLtuBwWqxDa3Ft2aYINtk9mDLmbD43HyzbHkoqkrjblSkKtD7r3uYBLjxBPeWhV9Ozp42VJRl0P3WBbbW/0SJobJtTSD4N+zpQW0xbd7fxTUxJu/YjcC3SGQgx2aaAFVLjIrgPaAdGuR557k3P1DbvJSDr8gcb2d5fq7tlfQTOapsGcEPqNFA0Vbn+Att5647Xt4ql/aExPpb2Q3U6f2Neiu5PNucuG6vNFPvc7nug3AuqCEpFh73H+yIVL1Ld5XkzCZnchZq8gvmPgoGjcOaLja5SUoqh5bDVKJ7HGWtDezYXy/mEMz28wpPR1jqFjcbeKxGCOtEKpYe9AtKn8IRephu6AT29uy2bNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Update DAMON ABI document for the newly added data attribute report
> producer control sysfs files.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

