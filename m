Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8734DCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E316B0088; Fri,  5 Jun 2026 11:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E606B008C; Fri,  5 Jun 2026 11:15:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96B636B0092; Fri,  5 Jun 2026 11:15:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 875376B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:15:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F78CC0770
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:15:39 +0000 (UTC)
X-FDA: 84846208398.28.5FE1883
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5888F40010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:15:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAkHgqrh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of tamird@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tamird@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780672537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puhtAJbtTv10DbpMBzxxn4d8tkyueRSzpyS9PIcm/Do=;
	b=vmiCDYpp20lOxljTBfAGauEGPyKsBQWLf4tR3fPDqLdV+fWfqs8XVSd4wRbgACqYX6MyVv
	2QkVFx2cE9KLVTzDsW/XxmqN50PFbNowQl2bmABR+0aBCpmTw4iNN64ARVTMdtt36Lga/T
	qv0CoDaLil06WO6+3d64USiPaOIvOVE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAkHgqrh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of tamird@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tamird@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780672537;
	b=u5nplvyEBJyFJPzvqDNhTx74Cf3O94MxBNUypUEPb5Mk64zBJLA4oNlixPetE/pb7PlXR1
	CjdMhSLDuK7PfQBW/WeQXyZyNyy4O2E+3lM3lvpmpp2mkVaSn2eRrll7kVj3V8hCbPYq3W
	FjCkXJPpjMTobpl559/lYj91bIJ6ISU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31F6A40364;
	Fri,  5 Jun 2026 15:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8321F00898;
	Fri,  5 Jun 2026 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780672536;
	bh=puhtAJbtTv10DbpMBzxxn4d8tkyueRSzpyS9PIcm/Do=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=bAkHgqrhvi63nXp1C7VGteim+y4gX3V6BNOlfGB3MuR/OoTCl95ozYQpmoWVp0o8Z
	 oOOQ5UBAofckRS+WVkyQ01hS2CI9zCdJJ+Ag9+mQkd3X/VqYTcGSc+8l9g361rmSgD
	 S1G5QdXJMzt0GOg1cWWMsTIXMb7Arvfk2DHl4+QBw3SVHcHlKkyXE2uRTbdw/yxSed
	 1glD6bSHdeIlxKCglJydri+dhGRfBiW1XgVuN8ZN2VNEbQifjwUzat8yu74WuUAlGW
	 aUChmd43TXFT/rlxMXAKa2HnVXULJjewyCHp1aK0+qpADq0zq7snXGHOM7MdZY+3Yb
	 rzvz0PfohMfCw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 03/11] rust: xarray: add `XArrayState`
From: Tamir Duberstein <tamird@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Tamir Duberstein <tamird@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Daniel Gomez <da.gomez@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20260604-xarray-entry-send-v4-3-965f6028790e@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-3-965f6028790e@kernel.org>
Date: Fri, 05 Jun 2026 11:15:13 -0400
Message-Id: <178067251345.96312.12627213045914595867.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1380; i=tamird@kernel.org;
 h=from:subject:message-id; bh=0yZ8MNnL/6JmXr7ul0Kx6gDu12++TzJW8JGsu0EE8KQ=;
 b=owGbwMvMwCV2wYdPVfy60HTG02pJDFlKL4S28b9iVNtz/WnUqw+ODBmZC0qWyBXc7e/3/tM6p
 3OVrl5xx0QWBjEuBksxRZZE0UN701Nv75HNfHccZg4rE8gQaZEGBiBgYeDLTcwrNdIx0jPVNtQz
 NNIx0DFm4OIUgKk2kmb4X+QtM+1rgP7T2VOduqTWLS/YuDz2Y/m+C9dsTFbpdFb1z2RkOKP9o5z
 pe4NU8PPff/U4P99pEHyq3X3zuUnTthl775vrswIA
X-Developer-Key: i=tamird@kernel.org; a=openpgp;
 fpr=5A6714204D41EC844C50273C19D6FF6092365380
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: kbirzp378d3e9fnh9szqjeemeigbs87k
X-Rspamd-Queue-Id: 5888F40010
X-HE-Tag: 1780672537-101957
X-HE-Meta: U2FsdGVkX1816LaLMALPpFAwXmwKTNZr/ROmPqPSPM+MubaRtI/TdXAMJnG9h72ODlIvqf9zMIiDtCezMLtcD18hpKvLcY+M55y8pV194i2aSLoqQ5zCdkF88Jr9VcXyCF2DYVSOaZukcGH+oZg87kBB08Dc/HYg1UOnsxOnhIyw+wyZ8AG94O9Bivuqj2SzZ34Gj3nUHry9eTdktjpsK02aQv+0qF1ej9X3uLy/IX1WXkQqXuMojEkOtk71SgHWGRY8pyJN6w7iN6Vy8bA4kP6/uEmQatXI+13LWwHo+wfSKHMl9+vgybRsRm0dMlt9aZPL2i+wUafjy3qEwzkSiazW7ysIcj4++1kEH4GT322ZvHpYv2T/n7YyycJB2l0jrU03+SlJz/YsuSKA4LDtDQDEDSCeVwZg1Ktt91blTDNe3Fph4T3hnaMG3WjOYVj+XedIQHU9aF69JuQqi/IUkK4YYbmLh0TaRk0N3YeeFjCuL5d9SEGrG1ansz8o6xDaX7QWGo1KNfsgf/xkqOw6/AhQ3KnLwWqVyAL8sSjvtqK/koftRGT0j2bQ2Mu4jzT6wlzigcEVx0zCUNq1toetmvj4mT8GNC6TwVj8iSqSgKHQrB79BXhmmkbPHrxCoR1ycg5SnpnS/39r48ouw01ZAX8q7hJzJW5aSsz1BheiNllqSiHuvAUd0hFTr/vCrPdghQvFYn+OnI3JDzp4Dadeij2QWPOoDgFOcPK4UrT5Zu7M3Nv9Sds933BDrOThDvTC6+H+Tyhq3tKXC8LPBzwF8cqtvJTCq0SbCU6vSiQdZKrS13LDRwWDGjhKSA1d8PWf3J6Od9+hOky91/Xo6Z1bziacF3Q/L80lSf+/FezsbusDGXhRcTUNuYoCZKdzHwtyOb8lDXGyD1CysnkvkKcrNiwSmdFPDJI/IQC/ccCMfNoarkzVLS9g/+Kj9QKpZK4AaHPkhUe/UYLqO1BUMYZ
 rpBqjyzr
 OpWVzRuT79qVqkR3n8q8oXDkVIwbVuAbBCtD41efIQlvuHcJqU9RgyRGmTO2rkEbodF8knTQfc+/bC+gg/GN/+iEWcxr1DUufs7Mr0Uv7T9qfIDrju38k6vO91HU16jNRMkRak9fjkQKfWf1/2PXkC19kMcp5o37Mg+EZv0M6Sv4OfX1LAvPUwVoNk40j+8RuU2mtfvci9jDjA8oQ2zEfloTztRlisel66n5eQronuGd91jOR98WxZwfw0/SX14DEMRZQdnpCKYZMyArJu+v6ramFBbgrsHM83zA0PT9celMczlnTOSNnhif/3EvlkDnzCfc8EErq4LNu72pWtMuTv35aumyuB7FN2dI8tJTIM96uOezuwYEPzuUte3Nh8Twl4Ahylast7GZjSFFWRDtkWrihGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 04 Jun 2026 21:58:09 +0200, Andreas Hindborg <a.hindborg@kernel.org> wrote:
> Add `XArrayState` as internal state for XArray iteration and entry
> operations. This struct wraps the C `xa_state` structure and holds a
> reference to a `Guard` to ensure exclusive access to the XArray for the
> lifetime of the state object.
> 
> The `XAS_RESTART` constant is also exposed through the bindings helper
> to properly initialize the `xa_node` field.
> 
> The struct and its constructor are marked with `#[expect(dead_code)]` as
> there are no users yet. We will remove this annotation in a later patch.

The review of this patch in v3 requested the next patch be absorbed into
it.

>
>
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index d54942aeb201..6d0d4905004a 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -299,6 +302,67 @@ pub fn store(
> [ ... skip 17 lines ... ]
> +impl<'a, T: ForeignOwnable> GuardRef for &mut Guard<'a, T> {
> +    type Value = T;
> +    fn xa_ptr(&self) -> *mut bindings::xarray {
> +        self.xa.xa.get()
> +    }
> +}

I'm having a hard time understanding the need for this trait, and it is
not described in the commit message at all. How is this different than
using Deref? `&mut T` has a blanket `Deref<Target = T>` impl.

-- 
Tamir Duberstein <tamird@kernel.org>

