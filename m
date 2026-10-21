Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68177606A324
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=OIvOqwSX
Received: by kanga.kvack.org (Postfix)
	id C379F6B0253; Wed, 21 Oct 2026 15:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE88D6B076B; Wed, 21 Oct 2026 15:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD88F6B076C; Wed, 21 Oct 2026 15:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 752756B0253
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:12:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFBFC16041A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:12:27 +0000 (UTC)
X-FDA: 85347579534.05.1D3C6F1
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id CD0001A000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:12:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OIvOqwSX;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792609945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Ktiyp+ELPbw8FY+ugNfMnIyLTm9cEpq+2a9YYb5vuE=;
	b=l0PPYcpI2Mi3hUXGAK5kiP+qBKhNY9+Gc/wXdMGp6Dcb9p1dvBl+deW/yockWsAPft3IR0
	HVBiIsh7JkYBHxt9ABz3CslAO2BowZfhiPMDWyEYs38J7KGu7FdwfqE+5xvKX3tmV49Z9H
	PDKRlep2+gaQ3QkSORe35P6/iw8Kd3U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792609945;
	b=Vzb+9CWttIanxEd6fxDn77EJKGVi7lK4PFn8CZxK2Jc7bORsXNa+wlfYc9+rRZgs7Pts/M
	vD9k5kYGF/OT9JRmzKwS/rVo0Rd10fE1BRhoPtP0KfXlBbovXPBYqCr0jqTca2DCahJ4G0
	8QEbLFFvtX31tteY7R2uzktwiMnAGO0=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OIvOqwSX;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so1408845a12.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:12:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792609944; cv=none;
        d=google.com; s=arc-20260327;
        b=hd2td+xdlDnwQEd8U8vkk8PjeNz2AVSZoe5apEJP0M2k1cU9b81P97hBP1ZVhIzsd3
         CZxeDEQXWYUCfROclnNOwMAHx9MKlqjPxmnofxV1MURhWRE2qQUy8hhTAKoFFHm1TSEP
         HF+g8YnbMJNDT857YJnyFp1JMh1p8C6/E5Ge+Tr2PuX4usoaVfHJEwq5fqqm5qIVoFzA
         H5IpFlF15JPdJk2OKFzKFywjBjB3QWVrrB1aNjfgckN1qvhUGiRePq9VvPTTXOqkWOeW
         YQzUo2ybkAa0WGdVIr5NR193++epCTw5G6TxUHpXCHATEdZD4zIeEdLcY2wWnWkkMy3n
         DbOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8Ktiyp+ELPbw8FY+ugNfMnIyLTm9cEpq+2a9YYb5vuE=;
        fh=4bA06gaUPaesnCDZQlnTzNz+diJ31EB/RQOKut0U/V0=;
        b=PWCevY9ojh1pQHa9QcpD9Lmjg5me/X6NzctYqP3pvGtFVKPtbcCaIJsVIevLpO3+Oj
         WwMBAWTPiz+bEtWqRiwBb9OyllMe5PlHq2ZNOxgHn825qUXyJAj9A0hX7Ia2x9XpKCvq
         wMGxlJlsiQA7Jm/82xvQI+IjBJyQrSonZHUul39FYuY5lqI/0VadMKRQ7CfsL60izpHI
         aFMQszEuSS++Uay4tM/ffgwLqLBcvF/jOHIDmCwtGtHOMR4gAuiKH7nT0nHTe55gad6i
         AMcN6MXjyf3TMKrnCX8gszKQ2JwxbW2IPoOIHQzx196jBMQ9ZQdX5KcT7rY4bms75Rek
         Lnkw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792609944; x=1793214744; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8Ktiyp+ELPbw8FY+ugNfMnIyLTm9cEpq+2a9YYb5vuE=;
        b=OIvOqwSXN4XRCWqyMQtOHuUc4wy6G8QX02ECpDFZPyRuWWpmX5kr9AEtBfaFjqD9Q6
         52jz2Eqj6HBsqPa68rEW6Ib7cnGpIGpHBJ2dDHOGNSsMwNOysVbVDSwGPUIU3Xy4iMMp
         MgVZK9sdt/640SHHdC6lL6KsVmcx6VKGjZDTdO0S5hhQ3iytJap2oTs2ZxIK2rGWXK8O
         o20F4ktRHE0/NQSAqLC8Dugml/8FkN5uGLD3eF5xPKn+r+l9MdPZiyPMMaopUTcGTYx6
         cUXFri8g5UvHrJzKQRh8dO+BLI+vrsNVjvUmN3DWCk6lMhRdEFztPzX6iKY7OxPmmz0f
         CzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792609944; x=1793214744;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Ktiyp+ELPbw8FY+ugNfMnIyLTm9cEpq+2a9YYb5vuE=;
        b=XawLnx6mEwj5432daBuoOOUNH1AmfkhG7Zh6Y8BuVdAVA8CDuItbcN7O6cE+kurK4L
         7OSTrAm4wcUlyISdzaS82ZYKhErNNaVZTRCjkU6DQzIXmDhnuVsgj/rNqeTpPpGqeFdZ
         5MPrYbjypXNyisLzKoajHB2SWMTHiMpUHc6iMjlTZkBvj26f4q6+fjA3jFTdFummQGU8
         rnWX37X89+zm2KjlOCsjXPfj0HjkuU3YbEOAlul+toIIaRuyBTpoJIu0bDUAcJOJEAC7
         zpdw09HCE9mltJQMUpiZYFDtXCpNNazYuj/6O64qjoztRctm1O+nAQOZX5HM24Grx1iZ
         4CVA==
X-Forwarded-Encrypted: i=1; AKwUvBxDPlSnOWTrW2pWtbyDVc1HNfIMFoCK5gRvPEguxt+3NOB6uZN8ipLO4PYrwIto+J70eHsWAiXwOQ==@kvack.org
X-Gm-Message-State: AFq9FYKEzlnQUa5zZaEy0Bhy7nqJysT6uj//0QObYq1S8gLWpr/X+6pd
	iVowwuwshE5C9959FqD6mMzMf9oFgqiN5WsJnIP31rr4DsJeLzv/IAx4mKvylPXXt8cPrqJFofK
	/2hg2al7/EAMRc+4tI11qoCgHsQJi7QMY/qthj8i5TQ==
X-Gm-Gg: AYBFou07t4JnDvAA9fDkXyevfWMPWckARVnghxAEiNhkUZzuV6lZnQtNgtlOuwOwWEE
	S4xZN8GruLHNVVaQGJksqF4oiYZwAmRqxQHVNU7Ej6UttdqzPBqZB8JEHarj6grGC/ZthLA+GeU
	fQFWlAzxkoQBV/k/vAx0M/gEq5fjwdVzxG6XmhgZk9gTZT8NO4tQ3xQCoYr3MyUykTZYbDfaqOW
	pGgMRq1RACfJpT3aqxGCxEQMckwr50D/Obu59fTwxScrDBC/Dn9Ro701AtENDJarJINwem/31NH
	LBFsBxsOjAZeUZV9F6pVqTp/q+3DrupXlMu9Iv3bhd9LnovIKYJLvH8hs49wbKr753/2t9unav8
	es8BJQQGIJL1ZGZm7mF+f5gYojgEF0L8M0aQxzRUN3MCA0rAbf/jv14i/4AAXnrxzsDY=
X-Received: by 2002:a05:6402:1585:b0:6b1:cea1:a011 with SMTP id
 4fb4d7f45d1cf-6b40893d0e9mr2089358a12.0.1792609944024; Wed, 21 Oct 2026
 12:12:24 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-2-tarunsahu@google.com>
 <CA+CK2bC_wc4LxvHe0TREbBP7esYW3pcMNtkGK-kqvf6MyvOh2g@mail.gmail.com> <9huzik2u6hs5.fsf@tarunix.c.googlers.com>
In-Reply-To: <9huzik2u6hs5.fsf@tarunix.c.googlers.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 15:11:47 -0400
X-Gm-Features: AclHuK9KaW6HqCjl5EInCO-rpSpt2TH4MByTskki3x2nY2ZO2voQyixCsqCAAkI
Message-ID: <CA+CK2bDyk=F7W3J=q3pKCjsr2wy_PLdgqgu+ywp0F5HL=VoMpA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] liveupdate: Rename handler compatible to name
To: tarunsahu@google.com
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, linux-pci@vger.kernel.org, 
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD0001A000A
X-Stat-Signature: id49dpjqx4amutfjhi3yq33998n61ryp
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792609945-878793
X-HE-Meta: U2FsdGVkX1/zGzidhaDy83aZEmH4q34CljwrJTloIOoAmeSxQj9LpjZ/MMwmH3JSGLC+b6Ed8iFgKvf8rF9LmikblJisDxb5Zh9ledAz774N1twtpwLy8xYYdJaovrPMl3HgZiychtXNyq8o4NP6Wir3tSJX1A66HgQgPiD9P0eQY/MkGgG/gNYkk7vQyvkGixQfyyo/x02syZNredcZbkK8W09IuuQzWfQprSOY70G3/eBkv5nuDAbbMp8RYV+/0vs7YpKuBtSv4KBZvA05aSlSCmt5zI/RBn48OikbSyIZRCQlSkLNiZ2JtjqIOXcbk3onXmLUwtnMBYgljukfNfvW1EVldxr1/iUWPcEQfqKc/tghuyJVPpjsbeEbbS9ALvc08DvRPkbMzeqhxnTlerLIDRGkCRmFK9nLTrZetn6fieDkD1l0P9dkKVbtx6YZ5f9U1Zf3kDohy1wtvwbR31NU4q5x0+Zrl/Q0XHzsop9ZlBwaBF1NQUXzE6Iaq70hplXmKwZFSi+MSUJaaFXv/aGpgc2+mFHP+7RuSKUJxFm0jXdpJi4FSZ2tHiaAL9B2fvqfjUU6Cqri2S4Cv9Uk5uUMLROcdVkwh82LPg54tc7YmwZwgsol5EUOi82dKcg//ziGxz43G3pkpYiBnKk7zOYVLEdFcR0CbjwGkTG9GUA6bJBkadXvQnk8fJCY835OBcafou2HtdV/nBhSs3wtEy0IrL18dAVDiBgOh2NIGvCYAy4JmCrRpyoTk6CiElCFXsxuJv+aBnAgJGYZiYkeybDsc+w/EwsLK6hE7iwBxvob2hgZa/5jxatqWIxbv+HTRUF2f1OHxQiPi3bQZP2o2p3OmSLi++7+iXLWfFEEKmdgiQM2B02u+Cc+VMHFC4T1FtnRNkpDsXaadpxcWhlnoeq9Rm6RYblQZzmaVfO9ZcEqcurT/8GCOs6+Tly2sM+7hp02I/lwyi6BNPwJE0f
 aLFjp89x
 Wc1TqWRe5MDCTpW6zDeKIFgzXbHdcG7XWDe70v+AWyAdZCNUtsf9KdNguIbqoglE1JLG4CfL6j2TKkMgWXj41hHDbh+aX5B4G3ADvp4DpLH+9Dj527HEPJqkn09v5MdmlcgpoRMgqJcvGMz0PgXhv87zPrTEIWOFe8jktDYkBjqKMVvYTCXXO6TN68d3ujqdiHIRmoOyWzXh9GqtKnPrJoKCllodv96/Q3d5VkG90tqfriupHc1qUZYA85VgKU90jnKCLuTMBWLleQxvKGwFyZfL3/7XmmWcmKwoupq/etkrcNnZT1EF4+Nih86+c+oNE2YHB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 2:16=E2=80=AFPM <tarunsahu@google.com> wrote:
>
> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
>
> > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.c=
om> wrote:
> >>
> >> File handler and File-Lifecycle-Bound (FLB) identifiers name the
> >
> > Please use FLB directly, no need to spell it out.
> >
> >> registered handler or FLB rather than a monolithic compatibility versi=
on.
> >> Rename compatible to name across LUO headers, structures, and consumer=
s:
> >> - struct liveupdate_file_handler and struct luo_file_ser name field
> >> - LIVEUPDATE_HNDL_NAME_LENGTH (in include/uapi/linux/liveupdate.h) and
> >>   MEMFD_LUO_FH_NAME
> >> - struct liveupdate_flb name field, LIVEUPDATE_FLB_NAME_LENGTH,
> >>   PCI_LUO_FLB_NAME, and LIVEUPDATE_TEST_FLB_NAME
> >>
> >> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> >> ---
> >>  drivers/pci/liveupdate.c        | 10 ++++----
> >>  include/linux/kho/abi/luo.h     | 26 +++++++++----------
> >>  include/linux/kho/abi/memfd.h   |  4 +--
> >>  include/linux/kho/abi/pci.h     |  2 +-
> >>  include/linux/liveupdate.h      | 18 +++++--------
> >>  include/uapi/linux/liveupdate.h |  3 +++
> >>  kernel/liveupdate/luo_file.c    | 45 +++++++++++++++++---------------=
-
> >>  kernel/liveupdate/luo_flb.c     | 16 ++++++------
> >>  lib/tests/liveupdate.c          | 22 ++++++++--------
> >>  mm/memfd_luo.c                  |  2 +-
> >>  10 files changed, 73 insertions(+), 75 deletions(-)
> >>
> >> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> >> index 51695782ed42..3cf01d7d615c 100644
> >> --- a/drivers/pci/liveupdate.c
> >> +++ b/drivers/pci/liveupdate.c
> >> @@ -424,7 +424,7 @@ static struct liveupdate_flb_ops pci_liveupdate_fl=
b_ops =3D {
> >>
> >>  static struct liveupdate_flb pci_liveupdate_flb =3D {
> >>         .ops =3D &pci_liveupdate_flb_ops,
> >> -       .compatible =3D PCI_LUO_FLB_COMPATIBLE,
> >> +       .name =3D PCI_LUO_FLB_NAME,
> >>  };
> >>
> >>  static void pci_liveupdate_flb_put_outgoing(void)
> >> @@ -667,13 +667,13 @@ static struct pci_flb_incoming *pci_liveupdate_f=
lb_get_incoming(void)
> >>
> >>         /*
> >>          * Live Update is enabled and there is incoming FLB data, but =
none of it
> >> -        * matches pci_liveupdate_flb.compatible.
> >> +        * matches pci_liveupdate_flb.name.
> >>          */
> >>         if (ret =3D=3D -ENOENT)
> >>                 return NULL;
> >>
> >>         /*
> >> -        * There is incoming FLB data that matches pci_liveupdate_flb.=
compatible
> >> +        * There is incoming FLB data that matches pci_liveupdate_flb.=
name
> >>          * but retrieve failed (pci_flb_retrieve() returned an error o=
r LUO
> >>          * failed to acquire a reference to pci_liveupdate_flb_ops.own=
er).
> >>          */
> >> @@ -998,7 +998,7 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_is_incoming);
> >>   */
> >>  int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
> >>  {
> >> -       pr_debug("Registering file handler \"%s\"\n", fh->compatible);
> >> +       pr_debug("Registering file handler \"%s\"\n", fh->name);
> >>         return liveupdate_register_flb(fh, &pci_liveupdate_flb);
> >>  }
> >>  EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
> >> @@ -1009,7 +1009,7 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
> >>   */
> >>  void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh=
)
> >>  {
> >> -       pr_debug("Unregistering file handler \"%s\"\n", fh->compatible=
);
> >> +       pr_debug("Unregistering file handler \"%s\"\n", fh->name);
> >>         liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
> >>  }
> >>  EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
> >> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> >> index 288076de6d4a..5fb2f46425d7 100644
> >> --- a/include/linux/kho/abi/luo.h
> >> +++ b/include/linux/kho/abi/luo.h
> >> @@ -39,9 +39,9 @@
> >>   *     Multiple blocks are linked via the `next` field in the header.
> >>   *
> >>   *   - struct luo_file_ser:
> >> - *     Metadata for a single preserved file. Contains the `compatible=
` string to
> >> - *     find the correct handler in the new kernel, a user-provided `t=
oken` for
> >> - *     identification, and an opaque `data` handle for the handler to=
 use.
> >> + *     Metadata for a single preserved file. Contains the handler `na=
me` string
> >> + *     to find the correct handler in the new kernel, a user-provided=
 `token`
> >> + *     for identification, and an opaque `data` handle for the handle=
r to use.
> >>   *
> >>   *   - struct luo_flb_header_ser:
> >>   *     Header for the FLB array. Contains the total page count of the
> >> @@ -49,9 +49,9 @@
> >>   *     that follow.
> >>   *
> >>   *   - struct luo_flb_ser:
> >> - *     Metadata for a single preserved global object. Contains its `n=
ame`
> >> - *     (compatible string), an opaque `data` handle, and the `count`
> >> - *     number of files depending on it.
> >> + *     Metadata for a single preserved global object. Contains its FL=
B `name`
> >> + *     string, an opaque `data` handle, and the `count` number of fil=
es
> >> + *     depending on it.
> >>   */
> >>
> >>  #ifndef _LINUX_KHO_ABI_LUO_H
> >> @@ -84,18 +84,16 @@ struct luo_ser {
> >>         u64 flbs_pa;
> >>  } __packed;
> >>
> >> -#define LIVEUPDATE_HNDL_COMPAT_LENGTH  48
> >> -
> >>  /**
> >>   * struct luo_file_ser - Represents the serialized preserves files.
> >> - * @compatible:  File handler compatible string.
> >> + * @name:        File handler name string.
> >
> > We are renaming from cpmaptible to name; I am not sure that is
> > necessary. We can still use compatible for the same purpose as name.
> > Unless it really bothers people, but for me 'compatible' works just
> > the same.
>
> Yes it is necessary, For example if we have two handler for a single
> subsystem. We should refer it by handle this or handler that, not like
> handler with compatible string this and handler with compatible string
> that.

I still feel like compatability makes more sense to me. Take an example:

We have two file handlers for memfd (i.e., FH_OLD and FH_NEW): one has
compatibility =3D "memfd", and the other has compatibility =3D
"memfd_next_generation". The user chooses one of them to preserve the
memfd data, and the compatibility string is saved alongside the FD.
When the next kernel scans through the registered file handlers, it
must find exactly one that is compatible with the preserved data.

Pasha

>
> It ease the conversation and people will understand it quickly with
> name.
>
> ~Tarun
>
> >
> >>   * @data:        Private data
> >>   * @token:       User provided token for this file
> >>   *
> >>   * If this structure is modified, `LUO_ABI_COMPATIBLE` must be update=
d.
> >>   */
> >>  struct luo_file_ser {
> >> -       char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
> >> +       char name[LIVEUPDATE_HNDL_NAME_LENGTH];
> >>         u64 data;
> >>         u64 token;
> >>  } __packed;
> >> @@ -134,7 +132,7 @@ struct luo_session_ser {
> >>  } __packed;
> >
> > Unreleated to this patch, but should be handled by this work, let's
> > remove all the '__packed' attributes, the are not needed, we will
> > explicitly fill in all the holes, with reserved fields.
> >
> >>
> >>  /* The max size is set so it can be reliably used during in serializa=
tion */
> >> -#define LIVEUPDATE_FLB_COMPAT_LENGTH   48
> >> +#define LIVEUPDATE_FLB_NAME_LENGTH     48
> >>
> >>  /**
> >>   * struct luo_flb_header_ser - Header for the serialized FLB data blo=
ck.
> >> @@ -156,7 +154,7 @@ struct luo_flb_header_ser {
> >>
> >>  /**
> >>   * struct luo_flb_ser - Represents the serialized state of a single F=
LB object.
> >> - * @name:    The unique compatibility string of the FLB object, used =
to find the
> >> + * @name:    The unique name string of the FLB object, used to find t=
he
> >>   *           corresponding &struct liveupdate_flb handler in the new =
kernel.
> >>   * @data:    The opaque u64 handle returned by the FLB's .preserve() =
operation
> >>   *           in the old kernel. This handle encapsulates the entire s=
tate needed
> >> @@ -172,14 +170,14 @@ struct luo_flb_header_ser {
> >>   * If this structure is modified, `LUO_ABI_COMPATIBLE` must be update=
d.
> >>   */
> >>  struct luo_flb_ser {
> >> -       char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
> >> +       char name[LIVEUPDATE_FLB_NAME_LENGTH];
> >>         u64 data;
> >>         u64 count;
> >>  } __packed;
> >>
> >>  /* Kernel Live Update Test ABI */
> >>  #ifdef CONFIG_LIVEUPDATE_TEST
> >> -#define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)      "liveupdate-test-flb-v=
" #i
> >> +#define LIVEUPDATE_TEST_FLB_NAME(i)    "liveupdate-test-flb-v" #i
> >>  #endif
> >>
> >>  #endif /* _LINUX_KHO_ABI_LUO_H */
> >> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/mem=
fd.h
> >> index 08b10fea2afc..371ffd108a79 100644
> >> --- a/include/linux/kho/abi/memfd.h
> >> +++ b/include/linux/kho/abi/memfd.h
> >> @@ -87,7 +87,7 @@ struct memfd_luo_ser {
> >>         struct kho_vmalloc folios;
> >>  } __packed;
> >>
> >> -/* The compatibility string for memfd file handler */
> >> -#define MEMFD_LUO_FH_COMPATIBLE        "memfd-v2"
> >> +/* The name string for memfd file handler */
> >> +#define MEMFD_LUO_FH_NAME      "memfd-v2"
> >>
> >>  #endif /* _LINUX_KHO_ABI_MEMFD_H */
> >> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> >> index 9485ed73c351..973ca5b26dbd 100644
> >> --- a/include/linux/kho/abi/pci.h
> >> +++ b/include/linux/kho/abi/pci.h
> >> @@ -23,7 +23,7 @@
> >>   * incrementing the version number in the PCI_LUO_FLB_VERSION number.
> >>   */
> >>
> >> -#define PCI_LUO_FLB_COMPATIBLE "pci"
> >> +#define PCI_LUO_FLB_NAME "pci"
> >>  #define PCI_LUO_FLB_VERSION 2
> >>
> >>  /**
> >> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> >> index 6051abc0612c..475da5fc22ee 100644
> >> --- a/include/linux/liveupdate.h
> >> +++ b/include/linux/liveupdate.h
> >> @@ -90,10 +90,8 @@ struct liveupdate_file_ops {
> >>  /**
> >>   * struct liveupdate_file_handler - Represents a handler for a live-u=
pdatable file type.
> >>   * @ops:                Callback functions
> >> - * @compatible:         The compatibility string (e.g., "memfd-v1", "=
vfiofd-v1")
> >> - *                      that uniquely identifies the file type this h=
andler
> >> - *                      supports. This is matched against the compati=
ble string
> >> - *                      associated with individual &struct file insta=
nces.
> >> + * @name:               Unique handler name string (e.g., "memfd-v2")=
, matched
> >> + *                      against &struct luo_file_ser.name in the targ=
et kernel.
> >>   *
> >>   * Modules that want to support live update for specific file types s=
hould
> >>   * register an instance of this structure. LUO uses this registration=
 to
> >> @@ -102,7 +100,7 @@ struct liveupdate_file_ops {
> >>   */
> >>  struct liveupdate_file_handler {
> >>         const struct liveupdate_file_ops *ops;
> >> -       const char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
> >> +       const char name[LIVEUPDATE_HNDL_NAME_LENGTH];
> >>
> >>         /* private: */
> >>
> >> @@ -209,11 +207,9 @@ struct luo_flb_private {
> >>  /**
> >>   * struct liveupdate_flb - A global definition for a shared data obje=
ct.
> >>   * @ops:         Callback functions
> >> - * @compatible:  The compatibility string (e.g., "iommu-core-v1"
> >> - *               that uniquely identifies the FLB type this handler
> >> - *               supports. This is matched against the compatible str=
ing
> >> - *               associated with individual &struct liveupdate_flb
> >> - *               instances.
> >> + * @name:        The FLB name string (e.g., "iommu-core-v1") that uni=
quely
> >> + *               identifies this FLB type. In the target kernel, it i=
s
> >> + *               matched against the name stored in &struct luo_flb_s=
er.
> >>   *
> >>   * This struct is the "template" that a driver registers to define a =
shared,
> >>   * file-lifecycle-bound object. The actual runtime state (the live ob=
ject,
> >> @@ -221,7 +217,7 @@ struct luo_flb_private {
> >>   */
> >>  struct liveupdate_flb {
> >>         const struct liveupdate_flb_ops *ops;
> >> -       const char compatible[LIVEUPDATE_FLB_COMPAT_LENGTH];
> >> +       const char name[LIVEUPDATE_FLB_NAME_LENGTH];
> >>
> >>         /* private: */
> >>         struct luo_flb_private __private private;
> >> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/live=
update.h
> >> index 4043d4038712..509c6236720d 100644
> >> --- a/include/uapi/linux/liveupdate.h
> >> +++ b/include/uapi/linux/liveupdate.h
> >> @@ -46,6 +46,9 @@
> >>  /* The maximum length of session name including null termination */
> >>  #define LIVEUPDATE_SESSION_NAME_LENGTH 64
> >>
> >> +/* The maximum length of file handler name including null termination=
 */
> >> +#define LIVEUPDATE_HNDL_NAME_LENGTH 48
> >> +
> >>  /* The /dev/liveupdate ioctl commands */
> >>  enum {
> >>         LIVEUPDATE_CMD_BASE =3D 0x00,
> >> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file=
.c
> >> index a39992da504f..fb81239bedf3 100644
> >> --- a/kernel/liveupdate/luo_file.c
> >> +++ b/kernel/liveupdate/luo_file.c
> >> @@ -50,7 +50,7 @@
> >>   *
> >>   * 2. Freeze (Pre-Reboot): Just before the kexec, luo_file_freeze() i=
s called.
> >>   *    It iterates through all preserved files, calls their respective=
 .freeze()
> >> - *    operation, and serializes their final metadata (compatible stri=
ng, token,
> >> + *    operation, and serializes their final metadata (handler name, t=
oken,
> >>   *    and data handle) into a contiguous memory block for KHO.
> >>   *
> >>   * 3. Deserialize: After kexec, luo_file_deserialize() runs when sess=
ion gets
> >> @@ -220,7 +220,7 @@ static bool luo_token_is_used(struct luo_file_set =
*file_set, u64 token)
> >>   * 1. Validates that the @token is not already in use within the file=
_set.
> >>   * 2. Ensures the file_set's memory for files serialization is alloca=
ted
> >>   *    (allocates if needed).
> >> - * 3. Iterates through registered handlers, calling can_preserve() to=
 find one
> >> + * 3. Iterates through registered handlers, calling .can_preserve() t=
o find one
> >>   *    compatible with the given @fd.
> >>   * 4. Calls the handler's .preserve() operation, which saves the file=
's state
> >>   *    and returns an opaque private data handle.
> >> @@ -238,7 +238,7 @@ static bool luo_token_is_used(struct luo_file_set =
*file_set, u64 token)
> >>   *         -EBUSY if the file descriptor is already preserved by anot=
her session.
> >>   *         -EBADF if the file descriptor is invalid.
> >>   *         -ENOSPC if the file_set is full.
> >> - *         -ENOENT if no compatible handler is found.
> >> + *         -ENOENT if no compatible handler is found for the file typ=
e.
> >>   *         -ENOMEM on memory allocation failure.
> >>   *         Other erros might be returned by .preserve().
> >>   */
> >> @@ -456,9 +456,10 @@ static void __luo_file_unfreeze(struct luo_file_s=
et *file_set,
> >>   *    private data handle during this step.
> >>   *
> >>   * 2. Serializes Metadata: After a successful freeze, it copies the f=
inal file
> >> - *    metadata=E2=80=94the handler's compatible string, the user toke=
n, and the final
> >> - *    private data handle=E2=80=94into the pre-allocated contiguous m=
emory buffer
> >> - *    (file_set->files) that will be handed over to the next kernel v=
ia KHO.
> >> + *    metadata - the handler's name string, the user token, and the f=
inal
> >> + *    private data handle - into the pre-allocated contiguous memory =
buffer
> >> + *    (file_set->files) that will be handed over to the target kernel=
 via
> >> + *    KHO.
> >>   *
> >>   * Error Handling (Rollback):
> >>   * This function is atomic. If any handler's .freeze() operation fail=
s, the
> >> @@ -495,13 +496,13 @@ int luo_file_freeze(struct luo_file_set *file_se=
t,
> >>                 err =3D luo_file_freeze_one(file_set, luo_file);
> >>                 if (err < 0) {
> >>                         pr_warn("Freeze failed for token[%#0llx] handl=
er[%s] err[%pe]\n",
> >> -                               luo_file->token, luo_file->fh->compati=
ble,
> >> +                               luo_file->token, luo_file->fh->name,
> >>                                 ERR_PTR(err));
> >>                         goto err_unfreeze;
> >>                 }
> >>
> >> -               strscpy(file_ser->compatible, luo_file->fh->compatible=
,
> >> -                       sizeof(file_ser->compatible));
> >> +               strscpy(file_ser->name, luo_file->fh->name,
> >> +                       sizeof(file_ser->name));
> >>                 file_ser->data =3D luo_file->serialized_data;
> >>                 file_ser->token =3D luo_file->token;
> >>         }
> >> @@ -747,7 +748,7 @@ static int luo_file_deserialize_one(struct luo_fil=
e_set *file_set,
> >>
> >>         down_read(&luo_register_rwlock);
> >>         list_private_for_each_entry(fh, &luo_file_handler_list, list) =
{
> >> -               if (!strcmp(fh->compatible, ser->compatible)) {
> >> +               if (!strcmp(fh->name, ser->name)) {
> >>                         if (try_module_get(fh->ops->owner))
> >>                                 handler_found =3D true;
> >>                         break;
> >> @@ -756,9 +757,9 @@ static int luo_file_deserialize_one(struct luo_fil=
e_set *file_set,
> >>         up_read(&luo_register_rwlock);
> >>
> >>         if (!handler_found) {
> >> -               pr_warn("No registered handler for compatible '%.*s'\n=
",
> >> -                       (int)sizeof(ser->compatible),
> >> -                       ser->compatible);
> >> +               pr_warn("No registered handler for name '%.*s'\n",
> >> +                       (int)sizeof(ser->name),
> >> +                       ser->name);
> >>                 return -ENOENT;
> >>         }
> >>
> >> @@ -789,9 +790,9 @@ static int luo_file_deserialize_one(struct luo_fil=
e_set *file_set,
> >>   * in-memory linked list of 'struct luo_file' instances.
> >>   *
> >>   * For each serialized entry, it performs the following steps:
> >> - *   1. Reads the 'compatible' string.
> >> + *   1. Reads the handler 'name' string.
> >>   *   2. Searches the global list of registered file handlers for one =
that
> >> - *      matches the compatible string.
> >> + *      matches the handler name.
> >>   *   3. Allocates a new 'struct luo_file'.
> >>   *   4. Populates the new structure with the deserialized data (token=
, private
> >>   *      data handle) and links it to the found handler. The 'file' po=
inter is
> >> @@ -884,9 +885,9 @@ void luo_file_set_destroy(struct luo_file_set *fil=
e_set)
> >>  /**
> >>   * liveupdate_register_file_handler - Register a file handler with LU=
O.
> >>   * @fh: Pointer to a caller-allocated &struct liveupdate_file_handler=
.
> >> - * The caller must initialize this structure, including a unique
> >> - * 'compatible' string and a valid 'fh' callbacks. This function adds=
 the
> >> - * handler to the global list of supported file handlers.
> >> + * The caller must initialize this structure, including a unique 'nam=
e'
> >> + * string and valid 'fh' callbacks. This function adds the handler to=
 the
> >> + * global list of supported file handlers.
> >>   *
> >>   * Context: Typically called during module initialization for file ty=
pes that
> >>   * support live update preservation.
> >> @@ -908,11 +909,11 @@ int liveupdate_register_file_handler(struct live=
update_file_handler *fh)
> >>         }
> >>
> >>         down_write(&luo_register_rwlock);
> >> -       /* Check for duplicate compatible strings */
> >> +       /* Check for duplicate handler names */
> >>         list_private_for_each_entry(fh_iter, &luo_file_handler_list, l=
ist) {
> >> -               if (!strcmp(fh_iter->compatible, fh->compatible)) {
> >> -                       pr_err("File handler registration failed: Comp=
atible string '%s' already registered.\n",
> >> -                              fh->compatible);
> >> +               if (!strcmp(fh_iter->name, fh->name)) {
> >> +                       pr_err("File handler registration failed: Hand=
ler name '%s' already registered.\n",
> >> +                              fh->name);
> >>                         err =3D -EEXIST;
> >>                         goto err_unlock;
> >>                 }
> >> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> >> index cd715a7c1d99..222c6d7f821e 100644
> >> --- a/kernel/liveupdate/luo_flb.c
> >> +++ b/kernel/liveupdate/luo_flb.c
> >> @@ -178,7 +178,7 @@ static int luo_flb_retrieve_one(struct liveupdate_=
flb *flb)
> >>                 return -ENODATA;
> >>
> >>         for (int i =3D 0; i < fh->header_ser->count; i++) {
> >> -               if (!strcmp(fh->ser[i].name, flb->compatible)) {
> >> +               if (!strcmp(fh->ser[i].name, flb->name)) {
> >>                         private->incoming.data =3D fh->ser[i].data;
> >>                         refcount_set(&private->incoming.count, fh->ser=
[i].count);
> >>                         found =3D true;
> >> @@ -337,7 +337,7 @@ static void luo_flb_unregister_one(struct liveupda=
te_file_handler *fh,
> >>
> >>         if (!found) {
> >>                 pr_warn("Failed to unregister FLB '%s': not found in f=
ile handler '%s'\n",
> >> -                       flb->compatible, fh->compatible);
> >> +                       flb->name, fh->name);
> >>                 return;
> >>         }
> >>
> >> @@ -442,9 +442,9 @@ int liveupdate_register_flb(struct liveupdate_file=
_handler *fh,
> >>                 if (luo_flb_global.count =3D=3D LUO_FLB_MAX)
> >>                         return -ENOSPC;
> >>
> >> -               /* Check that compatible string is unique in global li=
st */
> >> +               /* Check that FLB name is unique in global list */
> >>                 list_private_for_each_entry(gflb, &luo_flb_global.list=
, private.list) {
> >> -                       if (!strcmp(gflb->compatible, flb->compatible)=
)
> >> +                       if (!strcmp(gflb->name, flb->name))
> >>                                 return -EEXIST;
> >>                 }
> >>
> >> @@ -596,9 +596,9 @@ void __init luo_flb_setup_incoming(u64 flbs_pa)
> >>   * preserved (i.e., its reference count is greater than zero), it wri=
tes its
> >>   * metadata into the memory region designated for Kexec Handover.
> >>   *
> >> - * The serialized data includes the FLB's compatibility string, its o=
paque
> >> - * data handle, and the final reference count. This allows the new ke=
rnel to
> >> - * find the appropriate handler and reconstruct the FLB's state.
> >> + * The serialized data includes the FLB's name string, its opaque
> >> + * data handle, and the final reference count. This allows the target
> >> + * kernel to find the appropriate FLB and reconstruct its state.
> >>   *
> >>   * Context: Called from liveupdate_reboot() just before kho_finalize(=
).
> >>   */
> >> @@ -614,7 +614,7 @@ void luo_flb_serialize(void)
> >>                 long count =3D refcount_read(&private->outgoing.count)=
;
> >>
> >>                 if (count > 0) {
> >> -                       strscpy(fh->ser[i].name, gflb->compatible,
> >> +                       strscpy(fh->ser[i].name, gflb->name,
> >>                                 sizeof(fh->ser[i].name));
> >>                         fh->ser[i].data =3D private->outgoing.data;
> >>                         fh->ser[i].count =3D count;
> >> diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
> >> index 4c08a7c6fb78..e4df09eed1f3 100644
> >> --- a/lib/tests/liveupdate.c
> >> +++ b/lib/tests/liveupdate.c
> >> @@ -17,7 +17,7 @@
> >>  static const struct liveupdate_flb_ops test_flb_ops;
> >>  #define DEFINE_TEST_FLB(i) {                                         =
  \
> >>         .ops =3D &test_flb_ops,                                       =
    \
> >> -       .compatible =3D LIVEUPDATE_TEST_FLB_COMPATIBLE(i),            =
    \
> >> +       .name =3D LIVEUPDATE_TEST_FLB_NAME(i),                        =
    \
> >>  }
> >>
> >>  /* Number of Test FLBs to register with every file handler */
> >> @@ -34,7 +34,7 @@ static int test_flb_preserve(struct liveupdate_flb_o=
p_args *argp)
> >>  {
> >>         ptrdiff_t index =3D argp->flb - test_flbs;
> >>
> >> -       pr_info("%s: preserve was triggered\n", argp->flb->compatible)=
;
> >> +       pr_info("%s: preserve was triggered\n", argp->flb->name);
> >>         argp->data =3D TEST_FLB_MAGIC_BASE + index;
> >>
> >>         return 0;
> >> @@ -42,7 +42,7 @@ static int test_flb_preserve(struct liveupdate_flb_o=
p_args *argp)
> >>
> >>  static void test_flb_unpreserve(struct liveupdate_flb_op_args *argp)
> >>  {
> >> -       pr_info("%s: unpreserve was triggered\n", argp->flb->compatibl=
e);
> >> +       pr_info("%s: unpreserve was triggered\n", argp->flb->name);
> >>  }
> >>
> >>  static int test_flb_retrieve(struct liveupdate_flb_op_args *argp)
> >> @@ -52,11 +52,11 @@ static int test_flb_retrieve(struct liveupdate_flb=
_op_args *argp)
> >>
> >>         if (argp->data =3D=3D expected_data) {
> >>                 pr_info("%s: found flb data from the previous boot\n",
> >> -                       argp->flb->compatible);
> >> +                       argp->flb->name);
> >>                 argp->obj =3D (void *)argp->data;
> >>         } else {
> >>                 pr_err("%s: ERROR - incorrect data handle: %llx, expec=
ted %llx\n",
> >> -                      argp->flb->compatible, argp->data, expected_dat=
a);
> >> +                      argp->flb->name, argp->data, expected_data);
> >>                 return -EINVAL;
> >>         }
> >>
> >> @@ -69,10 +69,10 @@ static void test_flb_finish(struct liveupdate_flb_=
op_args *argp)
> >>         void *expected_obj =3D (void *)(TEST_FLB_MAGIC_BASE + index);
> >>
> >>         if (argp->obj =3D=3D expected_obj) {
> >> -               pr_info("%s: finish was triggered\n", argp->flb->compa=
tible);
> >> +               pr_info("%s: finish was triggered\n", argp->flb->name)=
;
> >>         } else {
> >>                 pr_err("%s: ERROR - finish called with invalid object\=
n",
> >> -                      argp->flb->compatible);
> >> +                      argp->flb->name);
> >>         }
> >>  }
> >>
> >> @@ -103,7 +103,7 @@ static void liveupdate_test_init(void)
> >>                 err =3D liveupdate_flb_get_incoming(flb, &obj);
> >>                 if (err && err !=3D -ENODATA && err !=3D -ENOENT) {
> >>                         pr_err("liveupdate_flb_get_incoming for %s fai=
led: %pe\n",
> >> -                              flb->compatible, ERR_PTR(err));
> >> +                              flb->name, ERR_PTR(err));
> >>                 }
> >>
> >>                 if (!err)
> >> @@ -124,18 +124,18 @@ void liveupdate_test_register(struct liveupdate_=
file_handler *fh)
> >>                 err =3D liveupdate_register_flb(fh, flb);
> >>                 if (err) {
> >>                         pr_err("Failed to register %s %pe\n",
> >> -                              flb->compatible, ERR_PTR(err));
> >> +                              flb->name, ERR_PTR(err));
> >>                 }
> >>         }
> >>
> >>         err =3D liveupdate_register_flb(fh, &test_flbs[0]);
> >>         if (!err || err !=3D -EEXIST) {
> >>                 pr_err("Failed: %s should be already registered, but g=
ot err: %pe\n",
> >> -                      test_flbs[0].compatible, ERR_PTR(err));
> >> +                      test_flbs[0].name, ERR_PTR(err));
> >>         }
> >>
> >>         pr_info("Registered %d FLBs with file handler: [%s]\n",
> >> -               TEST_NFLBS, fh->compatible);
> >> +               TEST_NFLBS, fh->name);
> >>  }
> >>
> >>  MODULE_LICENSE("GPL");
> >> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> >> index 6b68220275eb..64f8b8cb75bd 100644
> >> --- a/mm/memfd_luo.c
> >> +++ b/mm/memfd_luo.c
> >> @@ -602,7 +602,7 @@ static const struct liveupdate_file_ops memfd_luo_=
file_ops =3D {
> >>
> >>  static struct liveupdate_file_handler memfd_luo_handler =3D {
> >>         .ops =3D &memfd_luo_file_ops,
> >> -       .compatible =3D MEMFD_LUO_FH_COMPATIBLE,
> >> +       .name =3D MEMFD_LUO_FH_NAME,
> >>  };
> >>
> >>  static int __init memfd_luo_init(void)
> >> --
> >> 2.56.0.212.g129ede20d9-goog
> >>

