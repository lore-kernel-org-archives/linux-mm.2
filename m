Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05CE606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 12:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LGoHY4Ix
Received: by kanga.kvack.org (Postfix)
	id 1E6696B05B2; Sun,  1 Nov 2026 07:32:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197666B05B3; Sun,  1 Nov 2026 07:32:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086BD6B05B4; Sun,  1 Nov 2026 07:32:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEC186B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:32:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57DB5120A36
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:32:41 +0000 (UTC)
X-FDA: 85386488922.12.D7C2EA7
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7BF5CC0005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:32:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LGoHY4Ix;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of salehmammadof@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=salehmammadof@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793536359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/agyZjyVt8cATb1twFRPt2O+9K+O5UwpIt4X+3S/kM=;
	b=y1rvJrnwSm0TN97LNiMl0LNyhmJ03bsIM6BNqO7JZ/Siw9dNVrc3aoRp9UbvZJGKz8au3k
	pJW0AO/AjEzMuGWmhRdrtHLaANr57tnGjx2HUzGQTyQCTQc4cplDA+RcUJOH3LTopfHwx8
	/vDGPbkMl43oSRWwQ441YhDYoooeReY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LGoHY4Ix;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of salehmammadof@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=salehmammadof@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793536359;
	b=mJ12mZmZam9m58DW40yIKUsMNVHbNcqw8ZpgBceMloKDIWAqzSM8dw6nchfJsKu5G4oH53
	4rwEB/1aGQV2bPeDWzDhbDR5h8oVZNWJIXEszremkmPfz0K6vkob/Nwn9WK6foeKlg1abi
	ZdNoIad2QFglvk3OS05mcVhdMRFSkpY=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1a2af4c8d00so2077927c88.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 04:32:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793536358; cv=none;
        d=google.com; s=arc-20260327;
        b=ax2BZVcH5dwHAqlSQZMgOYNCjVz5E0XLFQwGDDzq3G1ornXqIDxxjLQWp83uGB3sQg
         mjudxBxiqWWUZH01tljdACmjXIKGke5dSCaXOsVDqB3JVZ0aG7VpITjjQOCOXDwGwR23
         87ReNgP1wbP+okm0ujAgGznpNcgnYir/Toer4JBIUFCbMF9PABHJc44h9t3dwS8CWeCB
         b2dnf1Om9xWqehCHJkn7WNklLeRzl9oP/URNo8MeC3KXXEJ0BC2XQbIGBFIlrBA9qzuN
         oFQCTYhBbKMq1gv/elNtZYe8RJLHTtbSYBypZT/nYHAZUmNBBGP1h+2xrweBNoC+qUZX
         JOVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q/agyZjyVt8cATb1twFRPt2O+9K+O5UwpIt4X+3S/kM=;
        fh=2TSRbIYuQ1Lhz/nSQM8m78ve/MJyzCCa7Ye5M0I+Hqg=;
        b=aSys9ds//eFQMB7xCVQG6bwyDRLx6nBm01w0cq96z9H98kNHjs8nBErFB8wXBqP57u
         aOGI9BSzN7CIqgajMNaFUS8pX61+ObvezFjKAduemPIUr4LwsDrC9CXEFYgQvRwi87X9
         f4MCgK04DEzCMYsUBkyjPkSJ6hA3/izIodgyzvoc26wpRzWwNpZcNAtfVFjSfxu4e1us
         6sliHdeL2JKbrjL28sT/DpUTfqLAWTQBgDQLjybK3vh87NyAOaA0vI7nRmY7ORYOwpwz
         NO9ezunmr055UV+5RxH18/daE3OCuSdvd8qbImJ3xO+HC7u0EK1BbvH5S2/MVl4fbmFA
         2+9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793536358; x=1794141158; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q/agyZjyVt8cATb1twFRPt2O+9K+O5UwpIt4X+3S/kM=;
        b=LGoHY4Ix3a9YhonVKCtSJ/fpI3F+1l2xUvrE7GJ1orPbc44kFq8oUcUX289D4UPj2H
         ZJVfueJwVZOQiqOZ+O5ro6DD02tMowNNxINagz8Xn7/OZBd06+/sNS7Tr26zBN7VwVz4
         TJZn9+J14d1xPS35bPGXCisxXvwPDT5pA2UiH7WVS2cKvUVL+apQvCcI6qBmHGCV6BxJ
         sZs+CvkASckYhGTOhyIuj2UZXUM1F4AQkMgP2zm+YPcblWUeko8Qvw7UWmjRcMzsCn4Z
         qKBLbpyel1EOT9jteDWJsmZ7voFSZ5lQ2dc6pOl4QxSv1Ayg0IaMEaSUn/J3jsLU6uRR
         7mdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793536358; x=1794141158;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q/agyZjyVt8cATb1twFRPt2O+9K+O5UwpIt4X+3S/kM=;
        b=flM89D+q4a3yM4Ox5nStM50rn1PgOzXejMq/x3O4HO486X6h+h9kvjjjO2AiZr5Z69
         dtxVC57WT1/NTKyMcnmzYcYFM7l6EdBIHP+KjT27FoJLah6h0sXXSElDSnIwKKY6R7Zx
         rxBKd3ZCog+gkxJcF8VxU2HgAC3Z6JacVPe8uqzhDl2TQvLFIGNl3R8ADKdM3N/5buMy
         ndIejMbUHrYs5J7tggngQRh+ts2s5Dv5f9cLnxh/nSfd83VMCdIiqz8YncMMvIHK0ipv
         uLA7lHZkK2LQJ7wf3W1DkDzE+6NIbontfuwKU6QbsmVPnfPH01hq7zm/GUyQ3zNnCPKF
         Vt9Q==
X-Gm-Message-State: AFq9FYKGAaxrzsmz7slfXylc06AJzr8QHngOBl10ISX31mPbb22C9g5Y
	TouhCx2vSTjibgYE5IUnzc8fCiQOGQUCoCm6ZSp7dWX9/oCRTlHz+FuH4e9wtVAcL2v8qQQs2vW
	vSvwIP2a9tp2b/2gav1fwAHXE2ffVA74=
X-Gm-Gg: AYBFou0zqXyds9lZCfFVTiW8hAHBJuUqwf2oViFwcqwH5HTykqe59i0pdiLa65kN9Pz
	2l5pKYi75Ez9R7Ya1+0RhJ5ormUeVMsG3AQvx+Qpl6Vwk/By3smXzgEaJjYin1QiIg+Kvo9vZ7Y
	bS0m2pa0wT6g7hh7/vbuRgsuTF4bpqWF+if/g2Tdx13SxeJykel1qzTDoYCwSxb6NonIBZrURg1
	taR5x48VszpyyVAMHmT/ITNHbRKtU/xZhMYPVWJQj/tqttl/Yl0DP27J9W3cyXul6ATKHV9ZBfK
	VbtXr6U2jnCE37mnmFrEs1NyYjp1UPHGvaQgS1xqMxtfXBZyVylBaXvsaGJe61ychSlDAd9LNU9
	ddYz/2G7PPp1ELROshqDXgDN2OgOk0qv+Q1d1K4c5+ao6YTG0cJacsyqdmSNTIndcs9OYnvPnB/
	N+pg3GVZykv5Bn
X-Received: by 2002:a05:7022:1e13:b0:18d:ac5a:89ef with SMTP id
 a92af1059eb24-1ac5c17ab77mr9307258c88.31.1793536358037; Sun, 01 Nov 2026
 04:32:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAKu0nJUGwnmuuT6fBz0phH=1Nyi6BguH2PHvs9+hDnrc_X0zWw@mail.gmail.com>
 <o5sj6bswd6arkusrxj5w5ww3jwk5hz7ktzxvdik72h7c4uen5i@fnwkmk6hvuf5>
 <CAKu0nJWyt8OGYkYBdnUnWo3rT-FwKEwoTmsCe71vC4cfUcbE0Q@mail.gmail.com> <CAKu0nJX68hxKU=G+bNq5HaUF9yPPy2bS3ifo0O=qwcW1m010Lg@mail.gmail.com>
In-Reply-To: <CAKu0nJX68hxKU=G+bNq5HaUF9yPPy2bS3ifo0O=qwcW1m010Lg@mail.gmail.com>
From: Saleh Mammadof <salehmammadof@gmail.com>
Date: Sun, 1 Nov 2026 16:32:26 +0400
X-Gm-Features: AclHuK9CavhZo800DQzAzQO10otkNnV4JuvBZBEz5Zjm5Ys5TMPHW6k2u81iZSw
Message-ID: <CAKu0nJUB=K0Er_H7k7eDcLJzT_mrwfcyJJ3ikG7i+WXV9kv0xA@mail.gmail.com>
Subject: Re: filemap_invalidate_inode() - losing -EBUSY from invalidate_inode_pages2_range?
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, hch@lst.de, dhowells@redhat.com, 
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7BF5CC0005
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: m65gcqpx67axxbyuu4ciapp9nzqodg75
X-HE-Tag: 1793536359-86836
X-HE-Meta: U2FsdGVkX18fS/HbxRCQRGBENR1UFDD8wQhiyeHx00mul3OSrZ38SkY5lzGjFLfJLrZ+jyDa+YeXYLLyPTZbjcRfi8NMctKsa5zQSU6xknzocR1mnFfBUciNO9vhAFqgdQgLo2/xFacoMAHMaNAnNJKNULS7iSm+y1MUuvnR68/6iIU4yAw0HQtkU8DH1EH3SBsSrN0gXCgW+kuqWLzGfSbEPQN6M8jMvufhrrTb584YQG7H7N0O512fpX/a/wxwvWxsvIlLoEFX/Q4hdBwCQ1ZDmO22UVfce21X1mKkbcz7qUPm8EGL1/K4KodcOvZJNw7iZuJVg1iDpf2x/nuEKdV8oclE133IM9Ad+bnFlBBFKo1aKdWNzjT5drxrWjPQ9NYNL2cZEMqW8ngKk6QMVg2j4H9PePSceoFwRPMylh4IYxx1VYRAFqf13IN3wt0E/ixhwqARsg+awyAdYTEJr41C9RQsHbCEU+fJl7zI4N5iwl/uD4gPUxi7YfV7cy4fdtvc4soJCZcZb64HsZ9Mzg/H8XCG3f3v+GvgpK5zZzNuXJC725KUtYFTqSYMSTziv5Ka6UR4foInyxcROovjkHhaxhBU5YiS8nF3Dgf5h6T/2ZphZi4BnGBXsN1JtmntgpilqMuPkY9sXm2ggljAXlkrsgghPnuw3T08YeNHl7QN0DKT0TLmBqvsPl98ecTP0nw1iCQyc2O0heITg8ZXozFLdmFSiB18s6PpMh14gHS1+HWzSgeipM9OcTXbwiJZMgbIAlqEfh9D4TkBLEirU/FpuUL2Fqj8zwCfpGE5NoeVGRorHtfyk3fhR0ceGrZ/c+rn6s4qU8mv6G+YnhEGBPNQ69W7OXxx/I1gCPNKaLprVxUIX8TDumwpn72evcjXqqhJRy0my31iOT/IEarFr/Ws84qDCx6LnBRHSx4y5EP0Hq8v69sKRqqbFlMwlCC7DSCk3LWSMm4oY6h4Zx0
 OJtaCeWJ
 Qoiu2KqbHERari7VAnAv9DbnQ44Vd8NAzF3019Z70tKKXrL9ltFWVIIiCz79qL0XzlOfIYSwzyl7y81blwR/6lodrvgdUtW9KftHdcNiaqfWAxUB5ND6Odn4UBQ7YwllDtwhfMBZPZ39JfhblO4A6fK+5IOCyvSf4GTaSCUj7I1H3UQssCJIRFxVGZkGFHQaukECtlqRqc1Ye8WyKCF0tG3mv1tOlMKODlLh8u/nd33Dt5yQ98qVerGrYJycuOZnyaNfUYq/nqFDhCGVJ8vew/TFbTgLT8jeufEH125dTcs3E5rHEq9hWn57e+xo8zB9vSJMagnqM0va48XUzCj024sk/GPviczm5q2vKFn3W38rrLdmRu6VWMJRdV7hC3TuUCQdBC2uOhriar0bCQjdpyeiKKTZeadkNYJ2CLxEm053nwBUbYmYsDtyWWPmiIiAC96fFQ1p4hJoVYNhdsRvtaJQ2W8ctAEy9JE/0hSNJ7b00P0GHUBoj0dqLx2J0YeHmTXQsnuT8T9272AZQwEVWe/UwXYOvOd+wgCOEiu5FOVU71rMocUh2HR21iv8iobOAj1ax
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

Thanks, Honza, and thanks for looping in the btrfs people.

To summarize: filemap_invalidate_inode() ignores the return value of
invalidate_inode_pages2_range() and returns only what
filemap_check_errors() finds on the mapping (AS_EIO/AS_ENOSPC). So
-EBUSY, and errors coming from folio_launder(), are dropped, and the
caller sees 0 even if a folio was left in the page cache.

I was not able to test this thoroughly, so please treat what follows as
a limited check only. On a debug kernel (btrfs on a loop device,
FICLONERANGE into a destination with cached pages) I forced -EBUSY from
invalidate_inode_pages2_range(), and filemap_invalidate_inode() returned
0 and the ioctl reported success. That only shows the error is dropped;
it does not show that -EBUSY can happen in practice. I also made a few
quick attempts to hit -EBUSY naturally on btrfs (dirty pages, splice,
dirty data outside the cloned range) and did not see it, but those
tests were small and may well be flawed, so I can=E2=80=99t say how reachab=
le
it is.

The callers differ:

btrfs reflink (fs/btrfs/reflink.c): the comment above the call says
btrfs_wait_ordered_range() is there so that the invalidation does not
fail, because a dirty folio would make btrfs_release_folio() return
false and the invalidation return -EBUSY, and that such a failure
can=E2=80=99t be ignored. The caller then checks ret < 0, so it seems to
expect -EBUSY to be returned.
netfs direct write and cifs appear to check the return value; afs
ignores it.

Question for the maintainers: would you want filemap_invalidate_inode()
to return the invalidation error (with -EIO/-ENOSPC from
filemap_check_errors() keeping precedence), or is the current behaviour
acceptable for your callers? If propagating it is what you=E2=80=99d want, =
I=E2=80=99m
happy to send a patch.

Thanks,
Saleh


On Wed, Oct 28, 2026 at 12:52=E2=80=AFAM Saleh Mammadof <salehmammadof@gmai=
l.com> wrote:
>
> Hi all,
>
> Thanks, Honza, and thanks for looping in the btrfs people.
>
> To summarize: filemap_invalidate_inode() ignores the return value of inva=
lidate_inode_pages2_range() and returns only what filemap_check_errors() fi=
nds on the mapping (AS_EIO/AS_ENOSPC). So -EBUSY, and errors from folio_lau=
nder(), are dropped, and the caller sees 0 even if a folio was left in the =
page cache.
>
> I did only a limited check of the effect. On a debug kernel (btrfs on a l=
oop device, FICLONERANGE into a destination with cached pages) I forced -EB=
USY from invalidate_inode_pages2_range(), and filemap_invalidate_inode() re=
turned 0 and the ioctl reported success. I also made a few quick attempts t=
o hit -EBUSY naturally on btrfs (dirty pages, splice, dirty data outside th=
e cloned range) and did not see it, but those tests were small and may well=
 be flawed, so I can=E2=80=99t say how reachable it is in practice.
>
> The callers differ:
>
> btrfs reflink (fs/btrfs/reflink.c): the comment above the call says btrfs=
_wait_ordered_range() is there so the invalidation does not fail, because a=
 dirty folio would make btrfs_release_folio() return false and the invalida=
tion return -EBUSY, and that such a failure can=E2=80=99t be ignored. The c=
aller then checks ret < 0, so it seems to expect -EBUSY to be returned.
> netfs direct write and cifs appear to check the return value; afs ignores=
 it.
>
> Question for the maintainers: would you want filemap_invalidate_inode() t=
o return the invalidation error (with -EIO/-ENOSPC from filemap_check_error=
s() keeping precedence), or is the current behaviour acceptable for your ca=
llers? If propagating it is what you=E2=80=99d want, I=E2=80=99m happy to s=
end a patch.
>
> Thanks,
> Saleh
>
>
> On Wed, Oct 28, 2026 at 12:51=E2=80=AFAM Saleh Mammadof <salehmammadof@gm=
ail.com> wrote:
>>
>> Thanks Jan, makes sense. I'll wait to hear what the btrfs folks think th=
e expected behavior should be.
>>
>> On Mon, Oct 26, 2026 at 5:34=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>>>
>>> Hi!
>>>
>>> On Sun 25-10-26 02:27:13, Saleh Mammadof wrote:
>>> > Been going through mm/filemap.c lately and something caught my eye in
>>> > filemap_invalidate_inode(). It calls filemap_fdatawrite_range() (or
>>> > the wbc variant) and then invalidate_inode_pages2_range(), but doesn'=
t
>>> > seem to check either return value directly - just falls through to
>>> > filemap_check_errors() at the end.
>>> >
>>> > The thing is, invalidate_inode_pages2_range() can return -EBUSY if a
>>> > folio won't evict (release_folio failing, launder_folio erroring out,
>>> > folio going dirty again mid-invalidation, etc), and filemap_check_err=
ors()
>>> > only looks at AS_ENOSPC/AS_EIO on the mapping. So that -EBUSY just...
>>> > disappears?
>>>
>>> Yes. Whether it matters or not depends on the caller I guess so you sho=
uld
>>> discuss with the users of filemap_invalidate_inode() what they'd like t=
he
>>> function to do. Adding btrfs people into the loop.
>>>
>>>                                                                 Honza
>>>
>>> > If I'm reading this right it could matter for callers that actually
>>> > branch on the return value - btrfs reflink bails out on a negative
>>> > return when clearing the destination cache, cifs sets
>>> > CIFS_INO_INVALID_MAPPING again on failure, that kind of thing. If the=
y
>>> > get back 0 when a folio was actually left behind, they'd think the
>>> > invalidation fully succeeded.
>>> >
>>> > Could be I'm missing some other path that catches this, genuinely not
>>> > sure. Haven't tried to reproduce it, just going off reading the code.
>>> > Let me know if I'm off base here.
>>> >
>>> > Saleh
>>> --
>>> Jan Kara <jack@suse.com>
>>> SUSE Labs, CR

