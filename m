Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC6D606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 22:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lq4Yfs+e
Received: by kanga.kvack.org (Postfix)
	id 338846B05B2; Sat, 24 Oct 2026 18:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9556B05B3; Sat, 24 Oct 2026 18:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9966B05B4; Sat, 24 Oct 2026 18:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E57B66B05B2
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 18:27:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6068B80488
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:27:31 +0000 (UTC)
X-FDA: 85358957502.19.0B085EC
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 93F5740002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:27:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lq4Yfs+e;
	spf=pass (imf07.hostedemail.com: domain of salehmammadof@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=salehmammadof@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792880849;
	b=y/flagKPjuuvW3IK6QVOax81Ql8EBsT+4IiaWOAIQ87fFpmKbdBN/IorhB2DrMtkzAa3Uw
	nlwLXAReIm71LlFGIchazOI9VrFK6gZkid2asW8GrQkrzEjoVOxuL1687a67IigpG5jVId
	9uWf+1p5Rc36un2lkV+4b18PFlSVUC0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lq4Yfs+e;
	spf=pass (imf07.hostedemail.com: domain of salehmammadof@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=salehmammadof@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792880849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IaP3x4ycswdz+LCLaNzxrhG2W+I4sYUGJaPMLWFt5NE=;
	b=ZQ4bK2mAH1+YoM7X4RrfzcJ4E3N89JBhAjRlxHymlesG9IhqAMaJKK7I/fCO+d27gsJRv4
	xzZUb4wcJDJZYQeAfW0cY1pQCvGTaaxf6Wf0YH4CaBl1KD+e6VJYRPFjrD69cKL45BPpkB
	hJ5nrBvA10XBjc/2Ok3dz2MlMrH6sUc=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-157fe9d771bso2351528c88.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:27:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792880848; cv=none;
        d=google.com; s=arc-20260327;
        b=m6hI/rGFqS/9iR3LE4w41jJPm1Jupc1QiCNRRv94KVSL9z8pmKvQqBtC1udJlGX9E9
         WHngz9krA+7tHrySbCx7Mt36JP+WFHeI5OQY37TQ/yLBM/OEolPLHjtzuuD5mCjXyMOf
         DY+bngokrlgyT0oRb/iw29C9FW2cB4/kakPx9S2Di22eISELwqP22aK6nDxY/mxFgV4i
         rztnOOOHDpQYY1tXGCLAXM0ge/bLYneyR16sqQaYDOS79s/rmImYFbDKHyWEHuSrSmHS
         thyGb7TxmfjZ4uoVruezwTyhnetaICc7ouucYs9rNSc2SizGon3UCdPkNEjCDFKIWfaA
         LGKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=IaP3x4ycswdz+LCLaNzxrhG2W+I4sYUGJaPMLWFt5NE=;
        fh=O5NqU8PuRqzacRKMpD4gJevcRcFxgtE0kCJ/eUvwivA=;
        b=fdW8s0TbAy7qkTFS+itCwiJcSkrt8rc3G90LyUrjTTpHP7SwI5RzLdU4b170iIFzWe
         WNPGOlo6TSAazmGC5xUKqnqJUCmgzhtLYBmbvxZ5WwIYPVnnVOONrHllL1Peb0ZyrC9c
         yBEtNjirLO1cND0LS58klkTqfrW+idSZ0ogu4eZ7aF6JuiGAlxgVAoW5ZuBKZ6vbR+Gb
         bh26OYstGnhLjNqNBku4Acs8I48MwkYo0s5JCJ/wUu+DKdElSv8UhSGH748fpi2i7w2V
         pv4uMn28FLJgai0GPzceBBLElJW/EJLkYUrAyRHREJechOkD24KTteSK29hVduLkf3fB
         pHYg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792880848; x=1793485648; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IaP3x4ycswdz+LCLaNzxrhG2W+I4sYUGJaPMLWFt5NE=;
        b=lq4Yfs+e2m0zJQL6uqefvAhHtczNfEuiNi31rq89FGIBwEeWYZMA2da1RoVU7RqQ8k
         HrbythSBjrykMMTWnMEKJp8zeIef021TqxeOnExeCKEaQA33JEuf7jm48xpjpQjrAgA+
         IoPlEpnTOs5FQNNlBJ0aOg3ZlU93scsMnom3QLRSzfDIfy38/Cbyx2r6SmYJazDFXGRB
         ArC7JyTJok4pN9M2Xd9OfS2Vu7zE3CJ10WWaecEQf7yB4x3b8q8CVc6c2VxAIMQdjTCx
         yr1tKg3USQxqeGhmtoLjyA5nLWpzeGKvqLisLFXcUw2ezPPfFJs0MCoqtSjbZ8MbMCBi
         CPVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792880848; x=1793485648;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IaP3x4ycswdz+LCLaNzxrhG2W+I4sYUGJaPMLWFt5NE=;
        b=ujaTJyYvPUt6A+WBMdRxGvCeSPELYUcieP0gY1+/dF59kqBRHpTCz2gaWypr0Mw5xQ
         dmusw9pvOPwAE0k84/lWRIOA1Pwb4Nt0Mcmgln72iRZ3kBEo/crUBFF1xs9S8ppdidYP
         s6MmZGVa9gO8S6r67XghhoDPPRC14LzeIrvoEo5aUonQXO9PMFSs/nBS6c/zlyYKw96y
         tWQbqC2SG8BPA4E3uHMs2RelLMCoJ1D0QFjrG+zlfZPaVe1NyvCFsbkI1BWbvah4vWQS
         XetIM+CfwBPttFND+auoGpJYpXhn54P7evGOHMg8YGsYuWsnpUmqDhVaBGGh0gaJUzq0
         rosA==
X-Gm-Message-State: AFq9FYLPF4MjqP5a9re+eaT6d1ApC4jmhI8PZLYCIZ6T2RAOdvHVMQjB
	1DbOIAV01PQgmIg7AP4RDILcezCLi0BrdI8kCx73TrnNroRv2g/Yp8wqWmQ49jnvV1Y617RUw64
	fWh8IeeF0ioVGNx7F/PD35E+3YZBeaTpRR7ANAK0=
X-Gm-Gg: AYBFou2sxdRp2jsa4yHFdW1LCj68lMXCprUJ+amUSxuBOm9oINUUllt2l/B1BkP7Fpv
	vboTBUjeMUCZ3/mrF/wjD7TleY0E1SeZlCe61tCdJs8ZzunxBRPCUfn2FMu/jFfkmUxSmOdsGql
	U1lvxbx4V8N/i2jYzfVteTUUbkK9zA7UCNKGVhrNeM2t4IT2gAGkW0niIEP/nW55ujqE3Jqd7UY
	RfvwcaMdnjnac7uzeFKwGEUB+KB2lkrWUtbsb9p0FGghHgCykzHJjcXKwSXFDUTF+wpOElRIH4W
	o5QOHhuNNL4YZ89lL9IqKdlC4QhD2dSfyVpqC6ugoXnI15+PjV8UdeXoK+YQuM3NudKgy8B6YGw
	/4Fg+M2ecj/OdPKvBRtDRjdKkWEiwLlBTf28lH6LnhJyCcaC+PhtGH/OnGxVxNp2z2w==
X-Received: by 2002:a05:701b:251b:b0:198:b1e:90d9 with SMTP id
 a92af1059eb24-19935810161mr3759787c88.10.1792880848232; Sat, 24 Oct 2026
 15:27:28 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Saleh Mammadof <salehmammadof@gmail.com>
Date: Sun, 25 Oct 2026 02:27:13 +0400
X-Gm-Features: AclHuK9r5WkBSr1cB2px3dlf0bgFerQDZqRMFPCNbZHn430sSIAQX_e_P49tldA
Message-ID: <CAKu0nJUGwnmuuT6fBz0phH=1Nyi6BguH2PHvs9+hDnrc_X0zWw@mail.gmail.com>
Subject: filemap_invalidate_inode() - losing -EBUSY from invalidate_inode_pages2_range?
To: linux-mm@kvack.org
Cc: jack@suse.cz, hch@lst.de, dhowells@redhat.com
Content-Type: multipart/alternative; boundary="00000000000015688a065e9d9a80"
X-Stat-Signature: d6csnkfrykmwa68kezoxf6rjb57og7bk
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 93F5740002
X-Rspam-User: 
X-HE-Tag: 1792880849-168343
X-HE-Meta: U2FsdGVkX1/Jhs1KHhxFbAZuduJUNLtHmgFSvlMjz/kMA8fSdYlqS/nLrYyMKajzXecy62YmtSoT+ZBsUPPKongoufbHZZelIohrdfuEMIm5z21jbooQB6Fp3GztWOE7Cm5AI3x7uDYSBPnCb45rTQM0RppImp4yae6zCnfWEKtUYnYgE8SDdImQA3qBfOSN0nN6eSM5xxW+V5aorpCNH0goUtlcBP6DcA6sfhgXtIn0VDuCwPhuAvOH4s5eiAn3ZXM0XbAMFNF5iHVwYJtt79GmAN4rY4trOeWY5UdFX/nX1gWmG68d2pgzSVyJ+bfkF6Nvkffep+C4RSoqDxZWyZMZmehp8Rd3PlSt7PhVXn6NtmpfphonrS0uL3X6Eql+ytjNW7oB0fmgF9VhphAKz91Ww7TiY1p+taOlDTt7AvM0Cb2wFxDXYsdZ+fdG3KfyRUVYQD2kLYbWuAXFv0fgdMwh2vkaz2sFF1k30PqOZySzQRQO/Wz/ZOdO4M92bLmo2VAo7Mz+J+4c+0AI0d2rQHy2l4GFga7V389HEjqRnS5d3SzgH3lEzD7RXSMn3L45dAnTzpaFHdsU/X8DDjqKEZSiEJgQRalARtHYQCL1zB4gARS/bigdzJIo438JDOetX5pGQQt/ltbjrrvs220OO94HYGQRltmtiAf/GVuJX+0TMdvscxZXzvevkkTpdZEf6PH3b6lLXDLq3jxGx1ODEqR8mXUjej1pPN0dNVhIge3eSN4/es+bpXe3MFDW3hhSYyFA4bXYjFDZNRih5byRfp0NPmRoDayR99tQpiH7cbJ8tU6iW5x82gopbKS4ql6Dkhw2cXu64Kh2s0qn2a+kf0dIoOuUF1fzS07NaCKf75jUtCdtxZK7zqW2nBpIbjLGtPsVgMSsqjIqQe7cn7ecMzlqzPel44YdN+B2ExI38J8onnQjgbHD2MdayZCTQY8TEgV1hORMaZET+gjImWb
 5mXxRWan
 1WLxX6kib5wv/WtJNi6qIX6sbUwFaQVmaK9YQ6lxUwY2NXhuxCthUlCV/BX109Qe/U2ehDnbCi80w0XRbSlHTEB+BI6sVk3sZNTdG1RLixAlh84MubaJodWcTPVii5xJAKgipIWDJAMYRQ3m/DIRIsMHIKMlJNcOLehpjccihsmNuY0oAbNe1BdqwCQHNZg2Z1ZaoGNUdc8I1/zkR575REcyz0a1h5/qJbtE/k/xUPsA9rV0QoE9/8hYHrR1yfRuXqddmbrnOJA4dLnr2lv6vpUvXKB4J2ODIi87h5LMXUZGexJdLRJvftSnTW2piajXeUqzn5tFCz509g8+W92CmNCmNpdmqEVd83Y2ei1wpYfyU+brrGz7DmMKdju3stupl1+bNGhAKy3ws/XwMs3kCwsjLl04D+Th/PFPrkDeDdACdMkS40MwImdDNlcSDZNtdyOvPEPz21tsAVebP6y6p/ReyY45iDXEUMV3plcnrKfSQ7j7C9oQRiJ2MsAw0lX3AMCoNJKVjL3z8eWHAdDjpX+A0uV0yLojPPxQBWvtN7YI2rt23sSeHX/FcB96op0xOQrqm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--00000000000015688a065e9d9a80
Content-Type: text/plain; charset="UTF-8"

Hi,

Been going through mm/filemap.c lately and something caught my eye in
filemap_invalidate_inode(). It calls filemap_fdatawrite_range() (or
the wbc variant) and then invalidate_inode_pages2_range(), but doesn't
seem to check either return value directly - just falls through to
filemap_check_errors() at the end.

The thing is, invalidate_inode_pages2_range() can return -EBUSY if a
folio won't evict (release_folio failing, launder_folio erroring out,
folio going dirty again mid-invalidation, etc), and filemap_check_errors()
only looks at AS_ENOSPC/AS_EIO on the mapping. So that -EBUSY just...
disappears?

If I'm reading this right it could matter for callers that actually
branch on the return value - btrfs reflink bails out on a negative
return when clearing the destination cache, cifs sets
CIFS_INO_INVALID_MAPPING again on failure, that kind of thing. If they
get back 0 when a folio was actually left behind, they'd think the
invalidation fully succeeded.

Could be I'm missing some other path that catches this, genuinely not
sure. Haven't tried to reproduce it, just going off reading the code.
Let me know if I'm off base here.

Saleh

--00000000000015688a065e9d9a80
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>Been going through mm/filemap.c lately and some=
thing caught my eye in<br>filemap_invalidate_inode(). It calls filemap_fdat=
awrite_range() (or<br>the wbc variant) and then invalidate_inode_pages2_ran=
ge(), but doesn&#39;t<br>seem to check either return value directly - just =
falls through to<br>filemap_check_errors() at the end.<br><br>The thing is,=
 invalidate_inode_pages2_range() can return -EBUSY if a<br>folio won&#39;t =
evict (release_folio failing, launder_folio erroring out,<br>folio going di=
rty again mid-invalidation, etc), and filemap_check_errors()<br>only looks =
at AS_ENOSPC/AS_EIO on the mapping. So that -EBUSY just...<br>disappears? <=
br><br>If I&#39;m reading this right it could matter for callers that actua=
lly<br>branch on the return value - btrfs reflink bails out on a negative<b=
r>return when clearing the destination cache, cifs sets<br>CIFS_INO_INVALID=
_MAPPING again on failure, that kind of thing. If they<br>get back 0 when a=
 folio was actually left behind, they&#39;d think the<br>invalidation fully=
 succeeded.<br><br>Could be I&#39;m missing some other path that catches th=
is, genuinely not<br>sure. Haven&#39;t tried to reproduce it, just going of=
f reading the code.<br>Let me know if I&#39;m off base here.<br><br>Saleh</=
div>

--00000000000015688a065e9d9a80--

