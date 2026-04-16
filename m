Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C66F8A16E
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 12:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FC586B0005; Thu, 16 Apr 2026 08:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADD46B0089; Thu, 16 Apr 2026 08:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3BB6B008A; Thu, 16 Apr 2026 08:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F07186B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:41:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E73A160870
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:41:46 +0000 (UTC)
X-FDA: 84664380612.04.2C6145E
Received: from mx.fmap.me (fmap.me [51.75.121.85])
	by imf11.hostedemail.com (Postfix) with ESMTP id C7DC64000A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:41:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=fmap.me header.s=mail header.b=J1J5BJtX;
	dmarc=pass (policy=reject) header.from=fmap.me;
	spf=pass (imf11.hostedemail.com: domain of ab@fmap.me designates 51.75.121.85 as permitted sender) smtp.mailfrom=ab@fmap.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776343305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LpJDpjvd754lZqTJVTbKzY3+WbuscGrA+ZFXy3r6Kto=;
	b=0HqwvKqdS8usAOczXuan42KyTpbGuZmxtH/KFBVlKiDOEdFDWw++RKDN1tqwtB5omHoNmW
	LZmYfLH8QqwZUmT1ObU08qi18is6xLqaqlmRewR4QLR7I415LK23x8M/e4OQviFAEXoOV1
	6rePCQ/xNAxBzpkko1qJKMMCySux2D0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=fmap.me header.s=mail header.b=J1J5BJtX;
	dmarc=pass (policy=reject) header.from=fmap.me;
	spf=pass (imf11.hostedemail.com: domain of ab@fmap.me designates 51.75.121.85 as permitted sender) smtp.mailfrom=ab@fmap.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776343305; a=rsa-sha256;
	cv=none;
	b=r2qJ12brTYPtNUPqRW3CUi3SBPY1RNba2KNR3MNXgdMeKS5TqCaGnWwxCoX/Wgn8SatIFX
	79hELc00r0hOEU/sm3S2iUFYwV2450GW67VR0N8IXLvBHEIvviodoAZ6/D5Q0QsiAcpp6B
	e8f+YJHSScTa5e8SUM7VXJstaOaZQmw=
Content-Type: multipart/mixed; boundary="------------PBWAN3Bbi1100Ta0o8JUsV1J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fmap.me; s=mail;
	t=1776343302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LpJDpjvd754lZqTJVTbKzY3+WbuscGrA+ZFXy3r6Kto=;
	b=J1J5BJtXHWa1d4QPJyoCDsnBwpevNEU3KBLF2+Dqp0dZBWtzoXUUA+CERjGgfkGjV5zx+Q
	G0CvVdo+Ow0eUyTRjmTB1q3VBQBTSWmaQEVPTO4Bo7TZFrGaKByzrSWkWXaSuUDPAQHK2w
	tkNBLeV1iWbfcLfHijgiNpMUToVLZGA=
Message-ID: <59ab54f6-680e-456e-91f4-0a26889844ef@fmap.me>
Date: Thu, 16 Apr 2026 19:41:37 +0700
MIME-Version: 1.0
Subject: Re: [fuse-devel] Debugging a stale kernel cache during file growth
To: Miklos Szeredi <miklos@szeredi.hu>, Matthew Wilcox <willy@infradead.org>
Cc: fuse-devel@lists.sourceforge.net,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Amir Goldstein <amir73il@gmail.com>, fuse-devel@lists.linux.dev,
 linux-mm <linux-mm@kvack.org>
References: <898a4e10-6193-4671-b3b1-7c7bc562a671@fmap.me>
 <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
 <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
Content-Language: en-US
From: Nikolay Amiantov <ab@fmap.me>
In-Reply-To: <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C7DC64000A
X-Stat-Signature: 3m5ec4d18ndjcewpoqob6s3szab1hgd4
X-HE-Tag: 1776343304-87182
X-HE-Meta: U2FsdGVkX19Hgc6mb/BFEkcj6Ebf9TdkorMQK6QwKfuN5VaHnLMQ0EJcol45YhI8hGnsZc7tV/zzKl1DZbPo/KgmIqR07rfTGdgoVkfqbgyOgxI2WbGeQETgRVsJulRAYnePGCpaui87/gMPEfuMIGuA1bFI/wCRD4VFJQLAGmYOgtzNRqDnZ2Uz6aVOJyKceeM6rCs30jiOqLxuqwZjsm+G8LR/kIS6S8IYK/LRsitDxkXaEaFJn89vIQLxQmv0xYb6D+lWNEMyiQoJ/vM2dlqRmDfyolv/0NLXMyznv6VeD7bm4j4jJdGOVEd6A0jagOnNIu1+AMKv/FCQjFhqnmI5iduoFSn38dsREr/nULbNmahBXmP4+GaEvYhmWFXIkP9YQJnfN3jRIsEMmZbbLsqUHQAHa4//qAvdd64gh8kwN5p74wt2AKen5a/dyj3/d1lPXV7drY8HEGA0KOA2MLYkzLYHfvDz1XzJFifHKmWq2B7In3b9RhL0EF4jt0OzLcLp7moAG7ESHGJ4za0qBf7LOc2sAvmzm5SiVbAJ7AavZuQxq7oUXmTE/0SUq5LiKkAkAE8jBUFkOQsRVXjtGqXjQECHYzcN9lKh7dbtojlBjraXQrAsqm9gEdIvzSfyTDYJbzLf9ytqrBjT4ArtX9GzuF3LHk/ypceYv7hSZnA5xdf2xuEsa7THaGHCrUUVLHiPsVYCR6+WlT1i//opR7z75HVRY04CS4JKN5hIoftZiO2kOBcdIwi8yA9AMrAYtXV771MIIRC488izL1bfUTyI0Yzyp6p1Jwxs5UbzzbPGLhkiAcUy1KCNqh6qASC/Ie6Yv8wN0BViQuObUJg6LIxwDLIeVZEJwMsRce9Losh1u3laSmLOvZAbnr1rT7PmHoY5WkrAKZK2jkVgkHyD6UZO02ApVQ1CEWmncoydqNj4tklcb77e9YBnk7OPUkQOBcsw/Db1FK4IVoseoYo
 KwoG89NW
 EQQ25uRl8bfmvx49tMke8tBGptnmHFXueXpDVY73UYa8i9g0RF9rs9A0pT6kOTzRwsfVFCz/6H2Ewp9UNDe+7cKMFB9QvyFUvBQvINghyPv3ciV6teUu3Rya7qDUIoc+GIIcI5t75grmTauvOTaUG3GvcrmCKfuh28zRC45Lv88K9ywSFgDZzkDMQ+Aaprdkg0DE7sp5RYkmb1ya5fhYhGodR04w1QNci5qqoVY1XSg6u4zr5Czev67PIw27eEnKHR8qqc4Tq7Uu4TXoUDzw4ScXvDMecLYLHHjwUIKdLOo0MKdmDwg6y3A/VPg0VIaOkxOWO3HqF64Rf1nW4+8VDRRm+NaMQzV6wPu/K8gMt6R+0GaEcl8xWK/vM4R4fV1trL8AyeJZUezUnoTRV8l+GOtK5BtfNv/nczk2Bsc5IJLtj//GjhAVR+kzYpqXQpEbCH4PD4g/RG4CGwzggapX756L6NJmHZvKp79DVHXaE6IQDmOl1HpwPzXl+KgUOwVCiFeGdXgs23zjjxPydGOJMI+LtMrXKQxSasjnplRVexpfPL6Eqcy8kHFX7ZBx0aslNuowRjds91eswcmi2BuvwAak3dRZEzjrK8fz6vz5l0NE/MH9wJRXKV1VMmI1wp77U89H1fHonAvhCw0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------PBWAN3Bbi1100Ta0o8JUsV1J
Content-Type: multipart/alternative;
 boundary="------------52NtMlTbHFL7c0NjiV8XF8Yj"

--------------52NtMlTbHFL7c0NjiV8XF8Yj
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/16/26 19:12, Miklos Szeredi wrote:
> I wonder if we could clear PG_uptodate on the page which had its zero
> bytes exposed by the i_size increase?

I've actually tried that first. The idea was to get or create a new page 
on the EOF boundary, lock it and poison it with an uptodate reset if we 
need to. But this resulted in an instantaneous EIO in my test. If I 
undestand correctly, this is because of another race condition:

* A fresh page gets created and read by FUSE; uptodate is true;
* The page is unlocked on return from `fuse_read_folio`;
* Simultaneously, we run `getattr`. The page gets locked, uptodate is 
reset, the page is unlocked;
* Now back from `fuse_read_folio`, `filemap_read_folio` gets this page, 
waits on `folio_wait_locked_killable` (waiting for the getattr to reset 
uptodate), and then checks `folio_test_uptodate`;
* The page is !uptodate, so an EIO is returned.

So it effectively results in inability to have a successful `read` when 
a `getattr` for a growing file happens simultaneously.

Finally, if I understand correctly, this also leaves a (much smaller) 
theoretical race condition in `filemap_read` between checking uptodate 
and getting the current inode size.

Attached is the patch with this attempt; please check that it does what 
you meant in case I misunderstood.

Cheers,
Nikolay.

--------------52NtMlTbHFL7c0NjiV8XF8Yj
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">On 4/16/26 19:12, Miklos Szeredi wrote:<span
      style="white-space: pre-wrap">
</span></div>
    <blockquote type="cite"
cite="mid:CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com">
      <pre wrap="" class="moz-quote-pre">I wonder if we could clear PG_uptodate on the page which had its zero
bytes exposed by the i_size increase?
</pre>
    </blockquote>
    <p>I've actually tried that first. The idea was to get or create a
      new page on the EOF boundary, lock it and poison it with an
      uptodate reset if we need to. But this resulted in an
      instantaneous EIO in my test. If I undestand correctly, this is
      because of another race condition:</p>
    <p>* A fresh page gets created and read by FUSE; uptodate is true;<br>
      * The page is unlocked on return from `fuse_read_folio`;<br>
      * Simultaneously, we run `getattr`. The page gets locked, uptodate
      is reset, the page is unlocked;<br>
      * Now back from `fuse_read_folio`, `filemap_read_folio` gets this
      page, waits on `folio_wait_locked_killable` (waiting for the
      getattr to reset uptodate), and then checks `folio_test_uptodate`;<br>
      * The page is !uptodate, so an EIO is returned.</p>
    <p>So it effectively results in inability to have a successful
      `read` when a `getattr` for a growing file happens simultaneously.</p>
    <p>Finally, if I understand correctly, this also leaves a (much
      smaller) theoretical race condition in `filemap_read` between
      checking uptodate and getting the current inode size.</p>
    <p>Attached is the patch with this attempt; please check that it
      does what you meant in case I misunderstood.</p>
    <p>Cheers,<br>
      Nikolay.</p>
  </body>
</html>

--------------52NtMlTbHFL7c0NjiV8XF8Yj--
--------------PBWAN3Bbi1100Ta0o8JUsV1J
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-fuse-fix-stale-page-cache-data-race-on-file-growth.patch"
Content-Disposition: attachment;
 filename*0="0001-fuse-fix-stale-page-cache-data-race-on-file-growth.patc";
 filename*1="h"
Content-Transfer-Encoding: base64

RnJvbSA1MTIxOTRiOTgyZmQwZWRiYzFkY2FhNTBmYWZhZDc1YjFiZTI2ZDQyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBOaWtvbGF5IEFtaWFudG92IDxhYkBmbWFwLm1lPgpE
YXRlOiBXZWQsIDE1IEFwciAyMDI2IDA3OjI4OjE5ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
ZnVzZTogZml4IHN0YWxlIHBhZ2UgY2FjaGUgZGF0YSByYWNlIG9uIGZpbGUgZ3Jvd3RoCgot
LS0KIGZzL2Z1c2UvaW5vZGUuYyB8IDM2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKystLQogMSBmaWxlIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZnMvZnVzZS9pbm9kZS5jIGIvZnMvZnVzZS9pbm9kZS5jCmlu
ZGV4IDczNWFiZjQyNmEwNi4uMjA3NDE4NjlhYzJmIDEwMDY0NAotLS0gYS9mcy9mdXNlL2lu
b2RlLmMKKysrIGIvZnMvZnVzZS9pbm9kZS5jCkBAIC0zMzQsMTAgKzMzNCw0MiBAQCB2b2lk
IGZ1c2VfY2hhbmdlX2F0dHJpYnV0ZXMoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZ1
c2VfYXR0ciAqYXR0ciwKIAkgKiBleHRlbmQgbG9jYWwgaV9zaXplIHdpdGhvdXQga2VlcGlu
ZyB1c2Vyc3BhY2Ugc2VydmVyIGluIHN5bmMuIFNvLAogCSAqIGF0dHItPnNpemUgY29taW5n
IGZyb20gc2VydmVyIGNhbiBiZSBzdGFsZS4gV2UgY2Fubm90IHRydXN0IGl0LgogCSAqLwot
CWlmICghKGNhY2hlX21hc2sgJiBTVEFUWF9TSVpFKSkKLQkJaV9zaXplX3dyaXRlKGlub2Rl
LCBhdHRyLT5zaXplKTsKKwlpZiAoIShjYWNoZV9tYXNrICYgU1RBVFhfU0laRSkpIHsKKwkJ
aWYgKFNfSVNSRUcoaW5vZGUtPmlfbW9kZSkgJiYgYXR0ci0+c2l6ZSA+IG9sZHNpemUpIHsK
KwkJCXN0cnVjdCBmb2xpbyAqZm9saW87CisJCQlwZ29mZl90IGluZGV4ID0gb2xkc2l6ZSA+
PiBQQUdFX1NISUZUOworCisJCQlzcGluX3VubG9jaygmZmktPmxvY2spOworCQkJZm9saW8g
PSBfX2ZpbGVtYXBfZ2V0X2ZvbGlvKGlub2RlLT5pX21hcHBpbmcsIGluZGV4LAorCQkJCQkJ
ICAgIEZHUF9MT0NLIHwgRkdQX0NSRUFULAorCQkJCQkJICAgIG1hcHBpbmdfZ2ZwX21hc2so
aW5vZGUtPmlfbWFwcGluZykpOworCQkJaWYgKCFJU19FUlIoZm9saW8pKSB7CisJCQkJc3Bp
bl9sb2NrKCZmaS0+bG9jayk7CisJCQkJaWYgKCF0ZXN0X2JpdChGVVNFX0lfU0laRV9VTlNU
QUJMRSwgJmZpLT5zdGF0ZSkpIHsKKwkJCQkJZm9saW9fY2xlYXJfdXB0b2RhdGUoZm9saW8p
OworCQkJCQlpX3NpemVfd3JpdGUoaW5vZGUsIGF0dHItPnNpemUpOworCQkJCX0KKwkJCQlz
cGluX3VubG9jaygmZmktPmxvY2spOworCisJCQkJZm9saW9fdW5sb2NrKGZvbGlvKTsKKwkJ
CQlmb2xpb19wdXQoZm9saW8pOworCQkJCWdvdG8gc2l6ZV91cGRhdGVkOworCQkJfQorCQkJ
c3Bpbl9sb2NrKCZmaS0+bG9jayk7CisJCQkvKgorCQkJICogRm9saW8gYWxsb2MgZmFpbGVk
IChFTk9NRU0pLiBSZWNoZWNrIGluIGNhc2UgYQorCQkJICogd3JpdGUvdHJ1bmNhdGUgc3Rh
cnRlZCB3aGlsZSB3ZSBkcm9wcGVkIHRoZSBsb2NrLgorCQkJICovCisJCQlpZiAoIXRlc3Rf
Yml0KEZVU0VfSV9TSVpFX1VOU1RBQkxFLCAmZmktPnN0YXRlKSkKKwkJCQlpX3NpemVfd3Jp
dGUoaW5vZGUsIGF0dHItPnNpemUpOworCQl9IGVsc2UgeworCQkJaV9zaXplX3dyaXRlKGlu
b2RlLCBhdHRyLT5zaXplKTsKKwkJfQorCX0KIAlzcGluX3VubG9jaygmZmktPmxvY2spOwog
CitzaXplX3VwZGF0ZWQ6CisKIAlpZiAoIWNhY2hlX21hc2sgJiYgU19JU1JFRyhpbm9kZS0+
aV9tb2RlKSkgewogCQlib29sIGludmFsID0gZmFsc2U7CiAKLS0gCjIuNDcuMAoK

--------------PBWAN3Bbi1100Ta0o8JUsV1J--

