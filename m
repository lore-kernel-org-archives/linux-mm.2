Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B50606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 05:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bU6Jup5B
Received: by kanga.kvack.org (Postfix)
	id 098596B00EF; Sun,  1 Nov 2026 01:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0497A6B05B1; Sun,  1 Nov 2026 01:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A5E6B05B2; Sun,  1 Nov 2026 01:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3D796B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 01:32:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 058431209E1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 05:32:00 +0000 (UTC)
X-FDA: 85385428800.03.367E775
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 39AAA40005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 05:31:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bU6Jup5B;
	spf=pass (imf11.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793511118;
	b=j57s4+4cKz+sn15JF9rlOW6XXY40B3HG0PhDMnboKnq/imYtoH7/RSd5GHQ+L3rY1ZrirR
	TptyVsV/hyAz8tKTs756SEXPYa+O6cybdIHr3CNz3bFD0QDC6r/Vy0P3Rq+fw/aht1Drv+
	UPZhkk5tWk+8hOS8TM2pH0h8UR1FZ7k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bU6Jup5B;
	spf=pass (imf11.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793511118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVwPKoe9RjiKHmMO6/+ENKIpPwM8V1vN0DPm5EJ76mY=;
	b=kQMmYRck5XMV6I4HQVKqoYoJ8+WquefDY9IFrTPS2JUo8dSpylpncXOX1Go5DaBz0Fyt1J
	v8JpehdzJvWdRvfR4TFxWwNzAt2BnxEqzdbnFmmSPeg4pVIYxCWzUmtYWMXRhtz3FR8AJM
	8e4l51tlGgO5zQ+CF16SNyLkQPJwJM4=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2eb0a52d605so44825ad.0
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793511117; x=1794115917; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XVwPKoe9RjiKHmMO6/+ENKIpPwM8V1vN0DPm5EJ76mY=;
        b=bU6Jup5B6nDdqy2npYJb41mEf+9VqRnMw0J1NrY6yzArp0xpSO1dGtl5BzyGHnUYJo
         CuCpmO3iNdYRQ5bne8/gOY5DN+n4YsmoIl8D0i9vlOXZapbhB8KC43sVGUOnQ+dn/CFm
         G9+oUeRg3iI9Ncg6A8ginuDD+OjwIy68aF1ZG+QYf2a9XKNezg4CJmHtXmjUC5CFXjUt
         DT48nDdg+RJt4X1BX1UoCtDiLUlg4d8RfpeyIXx8DRMSj4zNZrXntWYNFrWba7R/8tXm
         +IaQ1lEMgDOXghLieRax4Vfoe4Kkt7zxc/BvAP/qt3l5xjv2j3GSJRToA1ONjw/k068K
         c4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793511117; x=1794115917;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XVwPKoe9RjiKHmMO6/+ENKIpPwM8V1vN0DPm5EJ76mY=;
        b=19XUcjqevdYOCYxlUVi7O3TiDGLGEJjsJKGXsCl+9FilpleAgtHK8NbTN/phn2f6a5
         CoMK2Xq0yFVZUf9iIZy7C5bsigLKefwCGdXfD3ISt4vg65rBa9VzASHKzSwXIK/nyFNy
         XAiVYli83ezvav8VCivPUucdpl5nG+N2C75HhJMs91GFpvpIrEKzJmXQteVVMUb6Zukx
         czgKVCTsX/TKXLsk7SAB5ShOFRHlKQrODtLFAqzxikU65hUEOU9DZa1m7wfD0dKR8T3n
         5A1YoipDAHRYvuUoN5eR8g2P1eF6s4CrDxfcb5nrztIV5AoyRmqB68yaz5NNrJjX7LX7
         k1tQ==
X-Forwarded-Encrypted: i=1; AKwUvBzRIVNw1LBvQY/B0wvi0KCvmCp4xneyXzwxscWonJLivSdWOOv2P8sK4c7sA2SDx2ZATbUidjra6Q==@kvack.org
X-Gm-Message-State: APuU4Z8JR8nHbYwQ/2tsm8zcNWHfSX6+qwls4cUTTFEi2CiA5HsmtNYe
	jK+N17m27gsJwDLq7fFfRHmhvQywbi7efzlr/3Qr3ey018emd+8meZFps0vnTZfOEQ==
X-Gm-Gg: AYBFou0zmL5tlLWoziCfbyuKAHIk47YDOTLTgN3FPM6UZv0gGHZMDIzPRtqQQORkxZH
	uslGiUIavFxTTMwgsW1lBDu+yql0aFJfNvFfpcKox3geQN81s/lzga31rfEVarUpMTJVxqMzHmt
	j5iKn2HdBB3qd0YaOPlwnDfaYKGJUoHpLsPEU+M8WPWTYjZyIf0Aolzv/OEFt/YyuIXmnJwGq7C
	RESRMl7QrVVdgRfl6CNGEeGxF1bdayLXxAf9Innl/NL49aVUiwOLa5UPpzUOBLBXCV+W/MfF3Z/
	fxhqgMl2ewlkJUhi2VKi6qpA+6y5VuucVc9A8in1YWCBabGB/rGTrMYQ5LxIKPmE/0APoYHVDBm
	D0kHn+ALElhCMR/CmMoZllFBuiWJFftmN6WxM0AR42iGeR2NzTjkyLlrTKNNF+zuC8ah1jFY3AR
	yO/j5PyLmQzV9Smfns9IUqXkdj7Q8Ykbj7PWyBTn3zNMexUwH1eRf7W7AoBIyEnoRx9+4PzaoR1
	uhh+46/ipjRIfjSoHZdQloBhodzZOWTxn5kKtuDr0GJskeaXTvoIFQzg93jn16pvRkUipV51QU+
	RdLGAPjk3Wub22xLuwMy0i3Cpf3WJg2Xt7Kxnhm9sl6yLy4q0r7GnHfQFrV5X0SGz9TF2g4U68B
	DYs3VGenFnowRQuqEEN2t
X-Received: by 2002:a17:902:f541:b0:2df:42af:2f9f with SMTP id d9443c01a7336-2eb1ec33fd5mr15542125ad.1.1793511116342;
        Sat, 31 Oct 2026 22:31:56 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb09614e4bsm1987052a12.4.2026.10.31.22.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 22:31:54 -0700 (PDT)
Date: Sun, 1 Nov 2026 05:31:50 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/gup: check folio->mapping under folio lock in
 memfd_pin_folios()
Message-ID: <aubLkqA-aWrcklwS@google.com>
References: <20261031203540.2282507-1-skhawaja@google.com>
 <20261031194058.d3bd25ed950e5340ab595f07@linux-foundation.org>
 <CALCETrU76ThzLDbUfpoota5=xcoOS4aZrwgK2B3ELkYcFOjGJQ@mail.gmail.com>
 <20261031212507.31609e7ed27de35253b226c3@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261031212507.31609e7ed27de35253b226c3@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 39AAA40005
X-Stat-Signature: i7trhd3sr1dqk7ctbwwdn7oj7m16kyct
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793511118-115593
X-HE-Meta: U2FsdGVkX1/lEx+ea8GapFC7fhKT8uwBmFQXd1jLgU+qUFOVXsk8MRuaIdJzR2AryMgyd6e7665JFB95SRm/eYoBE3iYfv+kFJevT2GMBePv+aYeJSVcNdYyG0M++s7fFTS3XTitno6fHqsQVo7ZZwtXuhsdR1cOKUIGSBueMZyfAtt7KgULuVjfOChaXWWDqJjiN8u/VHqxHKWNhwG1IJE8pmCazi275FakOfwWw1sLetYZ8GQblGdjw1e8+kYv6N8bhnjp2Cg1KXFp9epTuQ/Yso7YGQo1CTKnhfVUtx3xavVq/pmP+t23kViVgd40G3BpQCKPS/EkQkF0zJhWTsN7+4ZwCjdMD/UUracY/ray/LOkDtJ31DN3RPwX5+LtSxIzwf5u/+eA92QyBlyHFKLSyP89pI8tAwq1KLPeUK2bPuR74mZc2S1e7X5hCw1pe34FyFVSUNYBcR7zUapfu/wQy5W6JkPrvRvLJVuWEblXCi7Hr7t1WnwyqSfUYZpLlLOXYQreM4CK3lJ78izjXK66uze5gwSBV3euHF8PBeJS7m+d8srWubHLOmOOVQvrDF/bqdxBEJG/ZdVCUdX2UMGuQgY8AljDEpDU4s+JvhPVQT9h4fL5aNfcEbgO6Na1OcY0ZNsJ9omi+ZsGW1YXNJlgp/Eg9uNdFlGboPPX3GaLo8garCEc9JFYk4AbZTZuA/FZ4K2TjAN+6eAwHoxrsX2IkIjahYLJnWI4G7ajqWp+PIku57coX81c/XWkSICWEz0yvq8oiO+Ku7F1Fed9j3UR2J1Hq/ElTq2RAER0cwgnwxPMKj9TGeCNZhhcH4+SqFwwuu/T6EHSpKTh1rloTULQdb2OVu6E7LBso+uaCpxT4W/zllWnIel4CFRnTGn+mrINoHb6sNcRcKIj6iK/obAwun3qEXLkI28Zyr3gK6bOMqhjjWJr7u+CTik5+HjPzzoj4e/fXn8RLcRdUBY
 QA2c/j9A
 VkKXGcm4HhnAW2G/3GvDDpNm7+99khp4XsLmRvbsx8igFJm8Tx0A77aZAMmaQhgRa92PZ/VPNNHTcMIQIR/TflrkMlCW3WnrFaxJdriE6Nh+ddOPp5y6E2pmm3YSowJmcvoZEWeufmkgqbtIVC9w6JFhFC3R7vrDxY04a+iXDs90N5QytuhDyt13hu9iyYhRVqfWk4xxjSbAQF8NyCWcWE698+zxog2/YXNcy+BBsx4UaJ+6aZOTYDqRPKoLmNB2bXR8ZGVdDCp/jAnIKEsv+UYfLTq4C6huNlWbEGhoVBjJdn0T6EKij+DpeLtL+kOdyiATbH3oG33fv205/LNtrtOwUaf8Cluge32fNwVsUafw4C2cK3ZvvfJl9Mu19CQtU+N9+xtfL+9feZv/pnUhEeayPf/tYkjr3k2Wby28RExDbI7nhHm5GPHJjyi2l5+lDOuvXOz+kiwgzSrkGaIHh6gOVGm+qA0KaS3rJfi9LyNrSUqwA8fOKuTh5QC24b+k+4fE1tF5JpisW+rYRng5ArjoA4LKxLjfs/SEd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 09:25:07PM -0700, Andrew Morton wrote:
>On Sat, 31 Oct 2026 20:20:03 -0700 Andy Lutomirski <luto@amacapital.net> wrote:
>
>> On Sat, Oct 31, 2026 at 7:40 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>> >
>> > On Sat, 31 Oct 2026 20:35:40 +0000 Samiullah Khawaja <skhawaja@google.com> wrote:
>> >
>> > > memfd_pin_folios() pins folios from the page cache without taking the
>> > > folio lock. So khugepaged or MADV_COLLAPSE can replace the folio after
>> > > its refcount check while memfd_pin_folios() still pins the old folio,
>> > > and the caller ends up with a folio that is no longer part of the memfd.
>> > >
>> > > Lock the folio and recheck folio->mapping before pinning it, like other
>> > > page cache users do. If the folio was removed, retry the folio lookup
>> > > from the index that was removed.
>> >
>> > Can we please include a clear description of the userspace-visible
>> > runtime effects of the bug?
>>
>> It's straight-up data corruption if you manage to trigger it, no?  If
>> you manage to race a memfd_pin_folios() against collapse,
>> memfd_pin_folios() will pin the wrong folio.
>>
>> Fortunately, there are a whopping three callers in the whole tree.
>> You can hit it from udmabuf or iommufd or memfd LUO.
>>
>> The former two will direct DMA to the wrong folio.  Fortunately it's
>> not UAF as the DMA will be directed to a folio that is still pinned,
>> but it's the wrong one.  DMA reads will read potentially stale data
>> and DMA writes will overwrite that stale data but not update the live
>> copy.  (The DMA will not be directed to some other application's
>> memory, just to a leftover copy of the calling application's memory.)
>>
>> As far as I know, the effect with LUO would be for stale data to
>> reappear in the memfd after handover.  With the patchset that started
>> this whole discussion applied, I think it might result in misdirected
>> DMA to freed memory (I do not stand by that claim at all), but that
>> patchset is not applied.
>
>Thanks.  How's this for a changelog?
>
>: memfd_pin_folios() pins folios from the page cache without taking the
>: folio lock. khugepaged or MADV_COLLAPSE can therefore replace a folio
>: after checking its refcount while memfd_pin_folios() still pins the old
>: folio. The caller then receives a folio which is no longer part of the
>: memfd.
>:
>: For udmabuf and iommufd, this can cause data corruption: DMA accesses
>: the detached folio rather than the live memfd contents. DMA reads can
>: return stale data, while DMA writes update the detached copy and are
>: lost from the live memfd. The detached folio remains pinned, so these
>: accesses do not constitute a use-after-free or target another
>: application's memory. For memfd live update, the stale contents can
>: reappear in the memfd after handover.
>:
>: Lock the folio and recheck folio->mapping before pinning it, like other
>: page cache users do. If the folio was removed, retry the folio lookup
>: from the index that was removed.

This explanation sounds good to me.

Please let me know if you want me to send a v2 with this changelog.

Thanks,
Sami

